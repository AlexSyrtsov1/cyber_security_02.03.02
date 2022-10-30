using ArgParse
using Match



function encrypt(message)
    len_line = length(message)

    if length(message) > 1
        message_final = [message[1] * message[i] for i in 2:len_line]
    else
        message_final = message
    end

    len_line = length(message_final[1])
    key = rand(UInt16, len_line)

    for i in 1:len_line
        key[i] = xor(UInt16(message_final[1][i]), key[i])
        print(key[i], " ")
    end
    
    println()
end



function decrypt(message, encoded)
    encoded_splited     = [split(i) for i in encoded]
    len_enc             = length(encoded_splited)
    len_mes             = length(message)
    encoded_final       = Any[]
    message_final       = Any[]

    if length(encoded) > 1
        encoded_final = [vcat(encoded_splited[1], encoded_splited[i]) for i in 2:len_enc]
    else
        encoded_final = encoded_splited
    end

    if length(message) > 1
        message_final = [message[1] * message[i] for i in 2:len_mes]
    else
        message_final = message
    end
    
    len = length(encoded_final[1])
    key = fill(0x0000, len)

    for i in 1:len
        key[i] = xor(parse(UInt16, encoded_final[1][i]), UInt16(message_final[1][i]))
    end

    println("key: $key")
end



cmd = ArgParseSettings()

@add_arg_table cmd begin
    "--interact", "-i"
        help        = "interactive mode"
        action      = :store_true

    "--message", "-m"
        help        = "message to encode"
        arg_type    = String
        default     = ""

    "--encoded_message", "-e"
        help        = "encoded message to find the key (should have same length as not encoded message and represent a string of UInt16). Example: -e=\"0x0061 0x0f1d0\""
        arg_type    = String
        default     = ""
end

cmd_parsed = parse_args(cmd)

if cmd_parsed["interact"]

    input_mes = String[]
    input_enc = String[]

    @label _mes_input_
        print(">> ")
        cmd_i = readline()

        @match cmd_i begin
            ":"     => @goto _enc_input_
            ":end"  => begin 
                        encrypt(input_mes)
                        input_mes = String[]
                        @goto _mes_input_
                    end
            ":exit" => exit()
            _       => begin
                        push!(input_mes, cmd_i)
                        @goto _mes_input_
                    end
        end

    @label _enc_input_
        print(">> ")
        cmd_i = readline()

        @match cmd_i begin
            ":"     => begin
                        input_mes = String[]
                        input_enc = String[]
                        @goto _mes_input_
                    end
            ":end"  => begin
                        decrypt(input_mes, input_enc)
                        input_mes = String[]
                        input_enc = String[]
                        @goto _mes_input_
                    end
            ":exit" => exit()
            _       => begin
                        push!(input_enc, cmd_i)
                        @goto _enc_input_
                    end
        end
end

len = length(cmd_parsed["message"])

if "" != cmd_parsed["encoded_message"]
    encoded = split(cmd_parsed["encoded_message"])

    if length(encoded) != len
        println("ERROR: length of encoded message (", length(encoded), ") != length of original message ( $len )")
        exit()
    end

    key = fill(0x0000, len)

    for i in 1:len
        key[i] = xor(parse(UInt16, encoded[i]), UInt16(cmd_parsed["message"][i]))
    end

    println("key: $key")
    exit()
end

if "" != cmd_parsed["message"]
    
    key = rand(UInt16, len)
    
    println("key: $key")

    for i in 1:len
        key[i] = xor(UInt16(cmd_parsed["message"][i]), key[i])
        print(key[i], " ")
    end
end