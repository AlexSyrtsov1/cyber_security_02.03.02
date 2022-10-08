---
# Front matter
lang: ru-RU
title: "Лабораторная работа 3"
subtitle: "Дискреционный подход разграничения прав пользователей с дополнительными атрибутами"
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

Получение практических навыков работы в консоли с атрибутами файлов для пользователей.

# Задание

Выполнить все указанные действия с атрибутами для разграничения прав пользователей.

# Выполнение лабораторной работы

1. От имени пользователя guest определите расширенные атрибуты файла
`/home/guest/dir1/file1` командой
`lsattr /home/guest/dir1/file1` (рис. -@fig:001).

![Определение атрибутов](11.png){ #fig:001 width=70% }

Как видно по изображению, никаких атрибутов не установлено.

2. Установите командой
`chmod 600 file1`
на файл file1 права, разрешающие чтение и запись для владельца файла (рис. -@fig:002).

![Установка прав](21.png){ #fig:002 width=70% }

3. Попробуйте установить на файл /home/guest/dir1/file1 расширенный атрибут a от имени пользователя guest:
`chattr +a /home/guest/dir1/file1`
В ответ вы должны получить отказ от выполнения операции (рис. -@fig:003).

![Установка атрибута](22.png){ #fig:003 width=70% }

4. Зайдите на третью консоль с правами администратора либо повысьте
свои права с помощью команды su. Попробуйте установить расширенный атрибут a на файл `/home/guest/dir1/file1` от имени суперпользователя:
`chattr +a /home/guest/dir1/file1` (рис. -@fig:004).

![Установка атрибута от пользователя root](43.png){ #fig:004 width=70% }

5. От пользователя guest проверьте правильность установления атрибута:
`lsattr /home/guest/dir1/file1` (рис. -@fig:005).

![Проверка установки атрибута](43.png){ #fig:005 width=70% }

6. Выполните дозапись в файл file1 слова «test» командой
`echo "test" /home/guest/dir1/file1`
После этого выполните чтение файла file1 командой
`cat /home/guest/dir1/file1`

Исходя из наблюдений ни от одного из пользователей не удалось выполнить запись.

7. Попробуйте удалить файл file1 либо стереть имеющуюся в нём информацию командой
`echo "abcd" > /home/guest/dirl/file1`
Попробуйте переименовать файл (рис. -@fig:006).

![Попытка удалить файл или перезаписать содержимое](23.png){ #fig:006 width=70% }

Результат: нет достаточных прав доступа.

8. Попробуйте с помощью команды
`chmod 000 file1`
установить на файл file1 права, например, запрещающие чтение и запись для владельца файла. Удалось ли вам успешно выполнить указанные команды?

Установка прав выполена успешно, в связи с чем возможность записи в файл или его чтение оказались невозможны.

9. Снимите расширенный атрибут a с файла /home/guest/dirl/file1 от
имени суперпользователя командой
`chattr -a /home/guest/dir1/file1`
Повторите операции, которые вам ранее не удавалось выполнить (рис. -@fig:007) (рис. -@fig:008)

![Снятие расширенного атрибута и установка другого атрибута на оставшийся файл](51.png){ #fig:007 width=70% }.

![Рассмотрение возможностей по записи и т.д., в отношении файлов после снятия одного атрибута и установки другого](31.png){ #fig:008 width=70% }

Так как файл после снятия атрибута удалось удалить, пришлось работать с новым файлом file.txt.

10. Повторите ваши действия по шагам, заменив атрибут «a» атрибутом «i».
Удалось ли вам дозаписать информацию в файл?

В пункте 9 показано выполнений всех действий. Как видно из рисунка 10, никакие из действий не возможны.


# Вывод

Удалось получить практические навыков работы в консоли с расширенными
атрибутами файлов.

# Библиография

Методичка