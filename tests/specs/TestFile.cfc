component extends="testbox.system.BaseSpec" {

    public function run() {
        describe("The File component", function () {
            it("should instantiate properly with defaults", function () {
                var f = getMockBox().prepareMock(new ecivis.helpers.fileupload.models.File());
                var ctu = getMockBox().prepareMock(new ecivis.helpers.fileupload.models.ContentTypeUtility());
                f.$property(propertyName="contentTypeUtility", mock=ctu);

                expect(f.exists()).toBe(false);
                expect(function () {
                    f.getPath();
                }).toThrow(type="UndefinedPropertyException");
                expect(function () {
                    f.getName();
                }).toThrow(type="UndefinedPropertyException");
                expect(function () {
                    f.getExtension();
                }).toThrow(type="UndefinedPropertyException");
                expect(function () {
                    f.getSize();
                }).toThrow(type="FileDoesNotExistException");
            });

            it("should instantiate properly with a path", function () {
                var f = getMockBox().prepareMock(new ecivis.helpers.fileupload.models.File(expandPath("/foo/bar/boo.baz")));
                var ctu = getMockBox().prepareMock(new ecivis.helpers.fileupload.models.ContentTypeUtility());
                f.$property(propertyName="contentTypeUtility", mock=ctu);

                expect(f.getPath()).toBe(expandPath("/foo/bar/boo.baz"));
                expect(f.getName()).toBe("boo.baz");
                expect(f.getExtension()).toBe("baz");
                expect(f.getContentType()).toBe("application/octet-stream");

                expect(function () {
                    f.getSize();
                }).toThrow(type="FileDoesNotExistException");
                expect(function () {
                    f.getHash();
                }).toThrow(type="FileDoesNotExistException");
            });

            it("should operate properly with a test file", function () {
                var f = getMockBox().prepareMock(new ecivis.helpers.fileupload.models.File());
                var ctu = getMockBox().prepareMock(new ecivis.helpers.fileupload.models.ContentTypeUtility());
                f.$property(propertyName="contentTypeUtility", mock=ctu);
                var testFile = getTempDirectory() & "file-upload-helper-test.txt";
                fileWrite(testFile, "Donny was a good bowler, and a good man. He was one of us.");

                debug(testFile);

                f.setPath(testFile);
                expect(f.exists()).toBe(true);
                expect(f.getName()).toBe("file-upload-helper-test.txt");
                expect(f.getExtension()).toBe("txt");
                expect(f.getContentType()).toBe("text/plain");
                expect(f.getHash()).toBe("d588f16c87ef14599cec4e50565a36ba6cc862cd556e215ea46c76f0ee03601b");
                expect(f.getSize()).toBe(58);
                expect(f.getFormattedSize()).toBe("58 bytes");

                f.delete();
                expect(f.exists()).toBe(false);
                expect(fileExists(testFile)).toBe(false);
            });
        });
    }

}