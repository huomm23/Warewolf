using Dev2.Common.Interfaces;
using Dropbox.Api.Babel;
using Dropbox.Api.Files;
// ReSharper disable ClassWithVirtualMembersNeverInherited.Global

namespace Dev2.Activities.DropBox2016.Result
{
    public class DropboxDownloadSuccessResult : IDropboxResult
    {
        private readonly IDownloadResponse<FileMetadata> _uploadAsync;

        public DropboxDownloadSuccessResult(IDownloadResponse<FileMetadata> uploadAsync)
        {
            _uploadAsync = uploadAsync;
        }

        public virtual IDownloadResponse<FileMetadata> GetDownloadResponse()
        {
            return _uploadAsync;
        }
    }
}