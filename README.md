# roboty_mobilne

Poszczególne pliki zawierają różne filtry:
1) komplementarny.m - Filtr komplementarny
2) mahony.m - Filtr Mahony'ego
3) Kalman.m - Filtr Kalmana
4) wlasny.m - Filtr własnego pomysłu

Na początku każdego z tych plików znajdują się wartości konfiguracyjne służące do strojenia filtrów. Każdy z filtrów zestawiany jest z prostą całką odczytu z żyroskopu.

Plik porównanie.m zawiera zestawienie wszystkich wykonanych filtrów. Również w nim możliwe jest strojenie filtrów na początku pliku.
Wyniki wyświetlane są jako wykresy dla poszczególnych osi.
Plik porównanie.m generuje plik z przefiltrowanymi danymi z wszystkich filtrów, który może być odczytany przez program gyro.jar(o ile znajdują się w tym samym katalogu).

Program gyro.jar został napisay w Javie 3d. Wizualizuje on wyniki filtracji dla wszystkich filtrów w przestrzeni 3D za pomocą trzech sześcianów.

Plik pomiary.csv zawiera własne pomiary wykonane przy użyciu ackelerometru-żyroskopu GY-521. W ciągu około 30 sekund był on wychylany w obu osiach do około 50 stopni w różne strony. W późniejszym etapie pomiaru czujnik był obracany jednocześnie w dwóch osiach.


