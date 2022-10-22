---
# Front matter
lang: ru-RU
title: "Лабораторная работа 7"
subtitle: ЭОднократное гаммированиеЭ
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

```

Код считывает строковые значения аргументов `-m` или `--message` (исходное сообщение), `-e` или `--encoded_message` (шифр) и, если `-e` или `--encoded_message` задано, то программа высчитывает значение ключа. В обратном случае шифруется значение строки `-m` или `--message`.

Результат кодирования (рис. -@fig:001).

![Проверка режима enforcing](1.png){ #fig:001 width=70% }

Результат нахождения ключа (рис. -@fig:002).

![Контекст безопасности](2.png){ #fig:002 width=70% }

# Ответ на контрольные вопросы

1. Поясните смысл однократного гаммирования. \
-Однократное гаммирование меняет значение исходного текста побитовым применением логического исключающего ИЛИ со случайными значениями для получения иного текста, которые мы называем ключом.

2. Перечислите недостатки однократного гаммирования. \
  2.1. Простота вычислений при попытке взлома. \
  2.2. Имея на руках исходный текст и шифр, возможно легко выявить значение ключа.

3. Перечислите преимущества однократного гаммирования. \
  3.1. Простота реализации. \
  3.2. Предусмотрена некая защита от частотного анализа шифра. То есть частота появления одного и того же зашифрованного символа не соответствует частоте появления исходного символа.

4. Почему длина открытого текста должна совпадать с длиной ключа? \
-Для исключения возможности расшифровать сообщение, применив частотный анализ, но, что важнее, сам ключ становится гораздо сложнее получить, если неизвестен исходный текст.

5. Какая операция используется в режиме однократного гаммирования,назовите её особенности. \
-В алгоритме применяется исключающее ИЛИ. Эта операция очень проста, так как реализована на уровне процессора. Из особенностей можно выделить то, что операция позволяет как зашифровать, так и расшифровать сообщение, не требуя применения обратных операций, сложность которых зачастую выше сложности шифрования.

6. Как по открытому тексту и ключу получить шифротекст? \
-Символы текста переводятся в совподающий со значениями ключа формат и на этих символах применяется исключающее ИЛИ.

7. Как по открытому тексту и шифротексту получить ключ? \
-Символы текста переводятся в совподающий со значениями шифра формат и на этих символах применяется исключающее ИЛИ.

8. В чем заключаются необходимые и достаточные условия абсолютной стойкости шифра? \
-Необходимо совпадение размера ключа с размером исходного текста, а сам ключ задан по закону равномерного распределения.

# Вывод

- Была разработана эффективная CLI программа
- Язык Julia показал, что может применятся в простых задачах на шифрование
- Был освоен алгоритм однократного гаммирования

# Библиография

Методичка