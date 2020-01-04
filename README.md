# UsersPerl
Celem projektu jest zapoznanie się ze sposobem tworzenia kont i konfiguracją środowiska pracy użytkowników.
Jest to zadanie wspólne dla wszystkich uczestników kursu.
Napisać skrypt do zakładania, kasowania i modyfikowania użytkowników, który będzie także konfigurował
ich środowisko pracy. Powinna istnieć możliwość:
• zakładania użytkownika z wyborem przy tym wolnego uid;
• opcjonalnie — wybór uid ze sprawdzeniem, czy jakiś istniejący użytkownik nie ma już takiego;
• generowania losowego hasła;
• kopiowania standardowych plików kropkowych z zadanego katalogu do domowego;
• zapisywanie danych użytkownika (login, uid, hasło)
• modyfikacji grup, do których należy użytkownik oraz innych danych dotyczących użytkownika
• kasowania kont użytkowników.
Skrypt powinien pracować w dwóch trybach:
• wsadowym, w którym wszystkie dane podawane będą jako parametry linii poleceń,
• interakcyjnym, w którym będzie się komunikował z administratorem za pomocą ładnego okienkowego
interfejsu i umożliwiał wybór grup, powłok, użytkowników do skasowania, itp. przy pomocy
przewijanych list menu.
Uwaga! Przy tworzeniu interfejsu należy skorzystać z perlowego modułu Tk.
