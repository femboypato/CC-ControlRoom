function downloadFile(url, path)
    local remoteStream = nil
    local attempts = 0
    local maxAttempts = 5

    while remoteStream == nil and attempts < maxAttempts do
        attempts = attempts + 1
        remoteStream = http.get(url)
        if remoteStream == nil then
            print("Failed to download " .. url .. ". Attempt " .. attempts .. " of " .. maxAttempts .. ". Retrying..")
            sleep(2)
        end
    end

    if remoteStream == nil then
        print("ERROR: Failed to download " .. path .. " after " .. attempts .. " attempts.")
        return
    end

    local remoteFile = remoteStream.readAll()
    local localFileWrite = fs.open(path, "w")
    if not fs.exists(path) then
        localFileWrite.write(remoteFile)
        print(path, " downloaded")
    else
        local localFileRead = fs.open(path, "r")
        if remoteFile ~= localFileRead.readAll() then
            localFileWrite.write(remoteFile)
            print(path, " updated")
        end
        localFileRead.close()
    end
    localFileWrite.close()
end

downloadFile("https://raw.githubusercontent.com/femboypato/CC-ControlRoom/refs/heads/main/files.lua", "files")

os.loadAPI("files")

fs.makeDir("lib")
for _, file in pairs(files.files) do
    downloadFile(file.url, file.path)
end

print("Finished")
print("Starting Program")

shell.run("program")
