---
# Front matter
lang: ru-RU
title: "Лабораторная работа 8"
subtitle: "Однократное гаммирование"
author: "Сырцов Александр Юрьевич"

# Formatting
toc-title: "Содержание"
toc: true # Table of contents
toc_depth: 2
lof: true # List of figures
lot: true # List of tables
fontsize: 12pt
linestretch: 1.5
papersize: a4paper
documentclass: scrreprt
polyglossia-lang: russian
polyglossia-otherlangs: english
mainfont: PT Serif
romanfont: PT Serif
sansfont: PT Sans
monofont: PT Mono
mainfontoptions: Ligatures=TeX
romanfontoptions: Ligatures=TeX
sansfontoptions: Ligatures=TeX,Scale=MatchLowercase
monofontoptions: Scale=MatchLowercase
indent: true
pdf-engine: lualatex
header-includes:
  - \linepenalty=10 # the penalty added to the badness of each line within a paragraph (no associated penalty node) Increasing the value makes tex try to have fewer lines in the paragraph.
  - \interlinepenalty=0 # value of the penalty (node) added after each line of a paragraph.
  - \hyphenpenalty=50 # the penalty for line breaking at an automatically inserted hyphen
  - \exhyphenpenalty=50 # the penalty for line breaking at an explicit hyphen
  - \binoppenalty=700 # the penalty for breaking a line at a binary operator
  - \relpenalty=500 # the penalty for breaking a line at a relation
  - \clubpenalty=150 # extra penalty for breaking after first line of a paragraph
  - \widowpenalty=150 # extra penalty for breaking before last line of a paragraph
  - \displaywidowpenalty=50 # extra penalty for breaking before last line before a display math
  - \brokenpenalty=100 # extra penalty for page breaking after a hyphenated line
  - \predisplaypenalty=10000 # penalty for breaking before a display
  - \postdisplaypenalty=0 # penalty for breaking after a display
  - \floatingpenalty = 20000 # penalty for splitting an insertion (can only be split footnote in standard LaTeX)
  - \raggedbottom # or \flushbottom
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

Освоить на практике применение режима однократного гаммирования.

# Задание

Нужно подобрать ключ, чтобы получить сообщение «С Новым Годом, друзья!». Требуется разработать приложение, позволяющее шифровать и дешифровать данные в режиме однократного гаммирования. Приложение должно:
1. Определить вид шифротекста при известном ключе и известном открытом тексте. 
2. Определить ключ, с помощью которого шифротекст может быть преобразован в некоторый фрагмент текста, представляющий собой один из возможных вариантов прочтения открытого текста.

# Основная идея алгоритма

Пусть у нас есть сообщение размером `n` символов, которое необходимо зашифровать. К нему мы создаём ключ из случайных чисел шестнадцатиричной системы счисления аналогичного размера. Символы сообщения переводятся в шестнадцатиричную систему и применяется логическое исключающее ИЛИ или oplus. Таким образом получаем шифр. Зная шифр и исходное сообщение, можно получить ключ, повторив операцию с элементами сообщения, переведённого в шестнадцатиричную систему, и элеентами шифра.

# Выполнение лабораторной работы

Написан следующий код на языке Julia

```jl
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
```

Код считывает строковые значения аргументов `-m` или `--message` (исходное сообщение), `-e` или `--encoded_message` (шифр) и, если `-e` или `--encoded_message` задано, то программа высчитывает значение ключа. В обратном случае шифруется значение строки `-m` или `--message`. Если же мы ввели `-i` или `--interact`, то программа работает в интерактивном режиме, где мы можем легко работать с большими объёмами текста.

# Ответ на контрольные вопросы

1. 1. Как, зная один из текстов (P1 или P2), определить другой, не зная при этом ключа?. \
-Использовать XOR на нужном шифротексте и исходном тексте, а затем на другом шифротексте.

2. Что будет при повторном использовании ключа при шифровании текста?. \
-Можно будет расшифровать сообщения без наличия ключа.

3. Как реализуется режим шифрования однократного гаммирования одним ключом двух открытых текстов. \
-Так же, как и при одном тексте, только теперь параллельно

4. Перечислите недостатки шифрования одним ключом двух открытых текстов \
-4.1. Можно расшифровать тексты без ключа, зная алгоритм.
-4.2. Можно проще выяснить значения ключа, не зная алгоритм.

5. Перечислите преимущества шифрования одним ключом двух открытых текстов.
-5.1. Если не знать исходный алгоритм, шанс расшифровать выяснить ключ выше, но всё ещё не достаточно велик. \
-5.2. Приложение обмена данными проще в реализации, так как не нужно знать множество ключей и постоянно генерировать новые.

# Вывод

- Была разработана эффективная CLI программа
- Язык Julia показал, что может применятся в простых задачах на шифрование
- Был освоен алгоритм однократного гаммирования

# Библиография

Методичка