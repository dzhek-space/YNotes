# YNotes

Результат учебных курсов [«Разработка под iOS»](https://academy.yandex.ru/posts/kak-osvoit-startovyy-nabor-ios-razrabotchika) организованных [Академией Яндекса](https://academy.yandex.ru/).

### Предварительный просмотр:

<p align="center">
<img alt="preview_ynotes" src="https://github.com/dzhek-space/YNotes/blob/master/preview_ynotes.gif" />
</p>

### Описание функциональности приложения:

*   Приложение позволяет создавать заметки. Каждой заметке можно присвоить цветовую метку из стандартного набора цветов, или выбрать любой другой цвет из палитры.

*   Также каждая заметка имеет дополнительные свойства: дата самоуничтожения, и приоритет важности. Полноценная реализация дополнительных свойств, в рамках курсов осталась невостребованной.

*   Локальное хранение заметок реализовано средствами фреймворка Core Data.

*   Удаленное хранение заметок реализовано на GitHub Gists. При первом входе через 'username / password' приложение создаст для себя 'personal access token', и новый gist. Далее доступ к GitHub осуществляется через 'token'. Все заметки храняться в виде единого json в этом gist в одном файле 'ios-course-notes-db'.

*   Дополнительно в приложении реализована фотогалерея (она не взаимодействует с backend-ом).

*   Часть приложения, которя работает с заметками построена на основе архитектурного паттерна VIPER.

**P.S.** Учитывайте факт того, что при прохождении курсов необходимо было максимально точно следовать учебным задачам. В связи с этим реализация некоторых моментов в приложении может показаться сомнительной и/или не полноценной.
