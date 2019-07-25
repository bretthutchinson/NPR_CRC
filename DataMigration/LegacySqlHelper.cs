using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Text;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Logging;

namespace DataMigration
{
    public class LegacySqlHelper : IDisposable
    {
        #region Fields

        private string _connectionString;
        private TimeSpan? _commandTimeout;
        private static IList<string> _safeStoredProcedures = new List<string> { "dbo.PSP_InfLog_Insert" };
        private static IDictionary<string, TimeSpan> _storedProceduresToCache = new Dictionary<string, TimeSpan>(StringComparer.OrdinalIgnoreCase);
        private static IDictionary<SqlCommand, CachedResult> _cachedStoredProcedureResults = new Dictionary<SqlCommand, CachedResult>(new SqlCommandEqualityComparer());

        #endregion

        #region Static Properties

        public static string DefaultConnectionString
        {
            get;
            set;
        }

        public static TimeSpan DefaultCommandTimeout
        {
            get;
            set;
        }

        public static IsolationLevel DefaultTransactionIsolationLevel
        {
            get;
            set;
        }

        public static IList<string> SafeStoredProcedures
        {
            get { return _safeStoredProcedures; }
        }

        public static IDictionary<string, TimeSpan> StoredProceduresToCache
        {
            get { return _storedProceduresToCache; }
        }

        #endregion

        #region Instance Properties

        public string ConnectionString
        {
            get
            {
                return !string.IsNullOrWhiteSpace(_connectionString) ? _connectionString : DefaultConnectionString;
            }

            set
            {
                _connectionString = value;
            }
        }

        public TimeSpan CommandTimeout
        {
            get
            {
                return _commandTimeout.HasValue ? _commandTimeout.Value : DefaultCommandTimeout;
            }

            set
            {
                _commandTimeout = value;
            }
        }

        #endregion

        #region Constructors

        public LegacySqlHelper()
        {
        }

        public LegacySqlHelper(string connectionString)
            : this()
        {
            _connectionString = connectionString;
        }

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
            }
        }

        #endregion

        #region Caching

        private class CachedResult
        {
            public DateTime TimeAdded { get; set; }
            public object Value { get; set; }
        }

        private class SqlCommandEqualityComparer : IEqualityComparer<SqlCommand>
        {
            public bool Equals(SqlCommand command1, SqlCommand command2)
            {
                if (command1.CommandType != command2.CommandType ||
                    !command1.CommandText.Equals(command2.CommandText, StringComparison.OrdinalIgnoreCase) ||
                    command1.Parameters.Count != command2.Parameters.Count)
                {
                    return false;
                }

                for (var i = 0; i < command1.Parameters.Count; i++)
                {
                    var command1Parameter = command1.Parameters[i];
                    var command2Parameter = command2.Parameters[i];

                    if (!command1Parameter.ParameterName.Equals(command2Parameter.ParameterName, StringComparison.OrdinalIgnoreCase) ||
                        !command1Parameter.Value.ToString().Equals(command2Parameter.Value.ToString(), StringComparison.OrdinalIgnoreCase))
                    {
                        return false;
                    }
                }

                return true;
            }

            public int GetHashCode(SqlCommand command)
            {
                var sb = new StringBuilder();
                sb.Append(command.CommandType);
                sb.Append(command.CommandText);

                foreach (SqlParameter parameter in command.Parameters)
                {
                    sb.Append(parameter.ParameterName);
                    sb.Append(parameter.Value);
                }

                return sb.ToString().ToUpperInvariant().GetHashCode();
            }
        }

        private static object GetCachedResult(SqlCommand command)
        {
            if (command.CommandType == CommandType.StoredProcedure && StoredProceduresToCache.ContainsKey(command.CommandText))
            {
                CachedResult cachedResult;
                if (_cachedStoredProcedureResults.TryGetValue(command, out cachedResult))
                {
                    if (DateTime.Now.Subtract(cachedResult.TimeAdded) < StoredProceduresToCache[command.CommandText])
                    {
                        return cachedResult.Value;
                    }
                    else
                    {
                        _cachedStoredProcedureResults.Remove(command);
                    }
                }
            }

            return null;
        }

        private static void SetCachedResult(SqlCommand command, object value)
        {
            if (command.CommandType == CommandType.StoredProcedure && StoredProceduresToCache.ContainsKey(command.CommandText))
            {
                _cachedStoredProcedureResults[command] = new CachedResult
                {
                    TimeAdded = DateTime.Now,
                    Value = value
                };
            }
        }

        public static void ExpireCache(string storedProcedureName)
        {
            var tempDictionary = new Dictionary<SqlCommand, CachedResult>(_cachedStoredProcedureResults);

            foreach (var tempItem in tempDictionary)
            {
                if (tempItem.Key.CommandText.Equals(storedProcedureName, StringComparison.OrdinalIgnoreCase))
                {
                    _cachedStoredProcedureResults.Remove(tempItem.Key);
                }
            }
        }

        #endregion

        #region Public Methods

        #region Connection/Command

        public SqlConnection CreateConnection()
        {
            return new SqlConnection(ConnectionString);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability", "CA2000:Dispose objects before losing scope")]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2100:Review SQL queries for security vulnerabilities")]
        public SqlCommand CreateCommand(CommandType commandType, string commandText, params SqlParameter[] parameters)
        {
            var command = new SqlCommand();
            command.Connection = CreateConnection();
            command.CommandType = commandType;
            command.CommandText = commandText;
            command.CommandTimeout = Convert.ToInt32(CommandTimeout.TotalSeconds);

            if (parameters != null && parameters.Length > 0)
            {
                foreach (var parameter in parameters)
                {
                    // convert empty strings to null
                    if (parameter.DbType == DbType.String)
                    {
                        var value = parameter.Value as string;
                        if (string.IsNullOrWhiteSpace(value))
                        {
                            parameter.Value = null;
                        }
                        else
                        {
                            parameter.Value = value.Trim();
                        }
                    }

                    // convert null parameters to DBNull
                    parameter.Value = parameter.Value ?? DBNull.Value;

                    command.Parameters.Add(parameter);
                }
            }

            // do not log calls to the logging stored procedure itself
            if (!command.CommandText.Equals("dbo.PSP_InfLog_Insert", StringComparison.OrdinalIgnoreCase))
            {
                InfLogger.Log(InfLogLevel.Debug, command.ToSqlString());
            }

            // validate for possible SQL injection
            if (command.CommandType == CommandType.Text || !SafeStoredProcedures.Any(sp => sp.Equals(command.CommandText, StringComparison.OrdinalIgnoreCase)))
            {
                command.Validate();
            }

            return command;
        }

        public SqlCommand CreateStoredProcedureCommand(string storedProcedureName, params SqlParameter[] parameters)
        {
            return CreateCommand(CommandType.StoredProcedure, storedProcedureName, parameters);
        }

        #endregion

        #region Transaction Control

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public void BeginTransaction()
        {
            throw new NotImplementedException();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "isolationLevel")]
        public void BeginTransaction(IsolationLevel isolationLevel)
        {
            throw new NotImplementedException();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public void CommitTransaction()
        {
            throw new NotImplementedException();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public void RollbackTransaction()
        {
            throw new NotImplementedException();
        }

        #endregion

        #region ExecuteReader

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public SqlDataReader ExecuteReaderCommand(SqlCommand command)
        {
            try
            {
                if (command.Connection.State != ConnectionState.Open)
                {
                    command.Connection.Open();
                    return command.ExecuteReader(CommandBehavior.CloseConnection);
                }
                else
                {
                    return command.ExecuteReader();
                }
            }
            catch (Exception exception)
            {
                InfLogger.Log(exception);
                throw;
            }
        }

        public SqlDataReader ExecuteReaderProcedure(string storedProcedureName, params SqlParameter[] parameters)
        {
            using (var command = CreateStoredProcedureCommand(storedProcedureName, parameters))
            {
                return ExecuteReaderCommand(command);
            }
        }

        #endregion

        #region ExecuteDataSet

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public DataSet ExecuteDataSetCommand(SqlCommand command)
        {
            var cachedResult = GetCachedResult(command);
            if (cachedResult != null)
            {
                return (DataSet)cachedResult;
            }

            try
            {
                using (var dataSet = new DataSet())
                {
                    dataSet.Locale = CultureInfo.InvariantCulture;

                    using (var adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(dataSet);
                    }

                    SetCachedResult(command, dataSet);
                    return dataSet;
                }
            }
            catch (Exception exception)
            {
                InfLogger.Log(exception);
                throw;
            }
        }

        public DataSet ExecuteDataSetProcedure(string storedProcedureName, params SqlParameter[] parameters)
        {
            using (var command = CreateStoredProcedureCommand(storedProcedureName, parameters))
            {
                return ExecuteDataSetCommand(command);
            }
        }

        #endregion

        #region ExecuteDataTable

        public DataTable ExecuteDataTableCommand(SqlCommand command)
        {
            var cachedResult = GetCachedResult(command);
            if (cachedResult != null)
            {
                return (DataTable)cachedResult;
            }

            using (var dataTable = new DataTable())
            {
                dataTable.Locale = CultureInfo.InvariantCulture;

                using (var dataReader = ExecuteReaderCommand(command))
                {
                    dataTable.Load(dataReader);
                }

                SetCachedResult(command, dataTable);
                return dataTable;
            }
        }

        public DataTable ExecuteDataTableProcedure(string storedProcedureName, params SqlParameter[] parameters)
        {
            using (var command = CreateStoredProcedureCommand(storedProcedureName, parameters))
            {
                return ExecuteDataTableCommand(command);
            }
        }

        #endregion

        #region ExecuteDataRow

        public DataRow ExecuteDataRowCommand(SqlCommand command)
        {
            using (var dataTable = ExecuteDataTableCommand(command))
            {
                return dataTable != null && dataTable.Rows.Count > 0 ? dataTable.Rows[0] : null;
            }
        }

        public DataRow ExecuteDataRowProcedure(string storedProcedureName, params SqlParameter[] parameters)
        {
            using (var dataTable = ExecuteDataTableProcedure(storedProcedureName, parameters))
            {
                return dataTable != null && dataTable.Rows.Count > 0 ? dataTable.Rows[0] : null;
            }
        }

        #endregion

        #region ExecuteScalar

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public object ExecuteScalarCommand(SqlCommand command)
        {
            var cachedResult = GetCachedResult(command);
            if (cachedResult != null)
            {
                return cachedResult;
            }

            try
            {
                if (command.Connection.State != ConnectionState.Open)
                {
                    try
                    {
                        command.Connection.Open();
                        var scalar = command.ExecuteScalar();

                        SetCachedResult(command, scalar);
                        return scalar;
                    }
                    finally
                    {
                        try { command.Connection.Close(); }
                        catch { }
                    }
                }
                else
                {
                    var scalar = command.ExecuteScalar();

                    SetCachedResult(command, scalar);
                    return scalar;
                }
            }
            catch (Exception exception)
            {
                InfLogger.Log(exception);
                throw;
            }
        }

        public object ExecuteScalarProcedure(string storedProcedureName, params SqlParameter[] parameters)
        {
            using (var command = CreateStoredProcedureCommand(storedProcedureName, parameters))
            {
                return ExecuteScalarCommand(command);
            }
        }

        public T ExecuteScalarCommand<T>(SqlCommand command)
        {
            return ExecuteScalarCommand(command).ConvertTo<T>();
        }

        public T ExecuteScalarProcedure<T>(string storedProcedureName, params SqlParameter[] parameters)
        {
            return ExecuteScalarProcedure(storedProcedureName, parameters).ConvertTo<T>();
        }

        #endregion

        #region ExecuteNonQuery

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public void ExecuteNonQueryCommand(SqlCommand command)
        {
            try
            {
                if (command.Connection.State != ConnectionState.Open)
                {
                    try
                    {
                        command.Connection.Open();
                        command.ExecuteNonQuery();
                    }
                    finally
                    {
                        try { command.Connection.Close(); }
                        catch { }
                    }
                }
                else
                {
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception exception)
            {
                InfLogger.Log(exception);
                throw;
            }
        }

        public void ExecuteNonQueryProcedure(string storedProcedureName, params SqlParameter[] parameters)
        {
            using (var command = CreateStoredProcedureCommand(storedProcedureName, parameters))
            {
                ExecuteNonQueryCommand(command);
            }
        }

        #endregion

        #region ExecuteEntity

        public T ExecuteEntityCommand<T>(SqlCommand command) where T : new()
        {
            var dataRow = ExecuteDataRowCommand(command);
            return dataRow.ToEntity<T>();
        }

        public T ExecuteEntityProcedure<T>(string storedProcedureName, params SqlParameter[] parameters) where T : new()
        {
            using (var command = CreateStoredProcedureCommand(storedProcedureName, parameters))
            {
                return ExecuteEntityCommand<T>(command);
            }
        }

        #endregion

        #region ExecuteEntityList

        public IEnumerable<T> ExecuteEntityListCommand<T>(SqlCommand command) where T : new()
        {
            using (var dataTable = ExecuteDataTableCommand(command))
            {
                return dataTable.ToEntityList<T>();
            }
        }

        public IEnumerable<T> ExecuteEntityListProcedure<T>(string storedProcedureName, params SqlParameter[] parameters) where T : new()
        {
            using (var command = CreateStoredProcedureCommand(storedProcedureName, parameters))
            {
                return ExecuteEntityListCommand<T>(command);
            }
        }

        #endregion

        #endregion
    }
}
