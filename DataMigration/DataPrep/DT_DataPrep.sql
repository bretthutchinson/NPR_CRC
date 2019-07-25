



CREATE PROCEDURE [dbo].[DT_DataPrep]

AS BEGIN

UPDATE crc3.dbo.CASUser
Set StateProvince_ID = 1 WHERE StateProvince_ID IS NULL

UPDATE crc3.dbo.TimeZone     Set TimeZoneName = 'International Data Line' WHERE HoursFromEST = -12
UPDATE crc3.dbo.TimeZone     Set TimeZoneName = 'Hawaiian Standard Time' WHERE HoursFromEST = -10
UPDATE crc3.dbo.TimeZone     Set TimeZoneName = 'Alaskan Standard Time' WHERE HoursFromEST = -9
UPDATE crc3.dbo.TimeZone     Set TimeZoneName = 'Atlantic Standard Time' WHERE HoursFromEST = -4
UPDATE crc3.dbo.TimeZone     Set TimeZoneName = 'Guam' WHERE HoursFromEST = 10
UPDATE crc3.dbo.TimeZone     Set TimeZoneName = 'Pacific Standard Time' WHERE HoursFromEST = -8
UPDATE crc3.dbo.TimeZone     Set TimeZoneName = 'Mountain Standard Time' WHERE HoursFromEST = -7
UPDATE crc3.dbo.TimeZone     Set TimeZoneName = 'Central Standard Time' WHERE HoursFromEST = -6
UPDATE crc3.dbo.TimeZone     Set TimeZoneName = 'Eastern Standard Time' WHERE HoursFromEST = -5

UPDATE crc3.dbo.ProgramSource     Set ProgramSourceCode ='BMP' WHERE ProgramSourceName = 'Ben Manilla Productions'
UPDATE crc3.dbo.ProgramSource     Set ProgramSourceCode ='N/A', ProgramSourceName='N/A' WHERE ProgramSourceName IS NULL

UPDATE crc3.dbo.Producer    Set LastName ='None' WHERE LastName IS NULL
UPDATE crc3.dbo.Producer    Set FirstName ='None' WHERE FirstName IS NULL

UPDATE crc3.dbo.Station SET MinorityStatusId = 5 WHERE MinorityStatusId > 6

--DELETE FROM CRC_Migration.dbo.ScheduleProgram
--DELETE FROM CRC_Migration.dbo.Schedule
--DELETE FROM CRC_Migration.dbo.StationUser
--DELETE FROM CRC_Migration.dbo.StationAffiliate
--DELETE FROM CRC_Migration.dbo.StationNote
--DELETE FROM CRC_Migration.dbo.Station
--DELETE FROM CRC_Migration.dbo.Affiliate
--DELETE FROM CRC_Migration.dbo.ProgramProducer
--DELETE FROM CRC_Migration.dbo.Program
--DELETE FROM CRC_Migration.dbo.ProgramFormatType
--DELETE FROM CRC_Migration.dbo.MajorFormat
--DELETE FROM CRC_Migration.dbo.CRCUser



END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[DT_DataPrep] TO [crcuser]
    AS [dbo];

