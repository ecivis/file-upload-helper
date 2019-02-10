component extends="testbox.system.BaseSpec" {

    public function run() {
        describe("The File Upload Service component", function () {
            it("should process a file uploaded using the alternative method", function () {
                var f = getMockBox().prepareMock(new ecivis.helpers.fileupload.models.File())
                    .$property(propertyName="contentTypeUtility", mock=getMockBox().prepareMock(new ecivis.helpers.fileupload.models.ContentTypeUtility()));
                var injector = getMockBox().createEmptyMock("tests.helpers.EmptyMock")
                    .$("getInstance").$args("File@FileUploadHelper").$results(f);
                var log = getMockBox().createEmptyMock("tests.helpers.EmptyMock")
                    .$("canDebug").$results(false);
                var fus = getMockBox().prepareMock(new ecivis.helpers.fileupload.models.FileUploadService())
                    .$property(propertyName="injector", mock=injector)
                    .$property(propertyName="log", mock=log);

                var payload = {
                    filename: "donny.html",
                    filedata: "PCFkb2N0eXBlIGh0bWw+CjxodG1sPgo8aGVhZD4KCTx0aXRsZT5Eb25ueTwvdGl0bGU+CjwvaGVhZD4KPGJvZHk+Cgk8aDE+RG9ubnk8L2gxPgoJPHA+RG9ubnkgd2FzIGEgZ29vZCBib3dsZXIsIGFuZCBhIGdvb2QgbWFuLiBIZSB3YXMgb25lIG9mIHVzLjwvcD4KPC9ib2R5Pgo8L2h0bWw+Cgo="
                };

                var uploadedFile = fus.processUploadAsData(payload.filename, payload.filedata);

                expect(uploadedFile.getName()).toBe("donny.html");
                expect(uploadedFile.getExtension()).toBe("html");
                expect(uploadedFile.getContentType()).toBe("text/html");
                expect(uploadedFile.getSize()).toBe(167);
                expect(uploadedFile.getHash()).toBe("1593d75feb17bd9f716b1a9c53d8c4785602c89c0470f90dc32933005aaa24ec");
            });
        });
    }

}