using System.IO;

namespace InfoConcepts.Library.Extensions
{
    public static class InfBinaryExtensions
    {
        public static byte[] ReadAllBytes(this Stream source)
        {
            using (var memoryStream = new MemoryStream())
            {
                var originalPosition = source.Position;
                source.Position = 0;

                var buffer = new byte[16 * 1024];
                int bytesRead;

                while ((bytesRead = source.Read(buffer, 0, buffer.Length)) > 0)
                {
                    memoryStream.Write(buffer, 0, bytesRead);
                }

                source.Position = originalPosition;
                return memoryStream.ToArray();
            }
        }
    }
}
