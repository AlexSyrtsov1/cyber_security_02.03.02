using ArgParse

cmd = ArgParseSettings()

@add_arg_table cmd begin
    "--message", "-m"
        help = "message to encode"
        arg_type = String
        required = true
    "--encoded_message", "-e"
        help = "encoded message to find the key (should have same length as not encoded message and represent a string of UInt16). Example: -e=\"0x0061 0x0f1d0\""
        arg_type = String
        default = ""
end

cmd_parsed = parse_args(cmd)
len = length(cmd_parsed["message"])

if "" == cmd_parsed["encoded_message"]
    key = rand(UInt16, len)
    println("key: $key")
    for i in 1:len
        key[i] = xor(UInt16(cmd_parsed["message"][i]), key[i])
    end
    println("message: $key")
    
else
    encoded = split(cmd_parsed["encoded_message"])

    if length(encoded) != len
        len_1 = length(encoded)
        println("ERROR: length of encoded message ($len_1) != length of original message ($len)")
        exit()
    end

    key = fill(0x0000, len)
    for i in 1:len
        key[i] = xor(parse(UInt16, encoded[i]), UInt16(cmd_parsed["message"][i]))
    end
    println("key: $key")
end
