# Dokumentacja projektu Fpay

## Opis ogólny

Fpay to aplikacja mobilna służąca do zarządzania wspólnymi wydatkami w grupach znajomych. Aplikacja umożliwia:

- Tworzenie grup wydatków
- Dodawanie znajomych do grup
- Śledzenie kwot do zapłaty
- Zarządzanie znajomymi i zaproszeniami

Aplikacja wykorzystuje Supabase jako backend do przechowywania danych i uwierzytelniania użytkowników.

## Struktura plików

### Główne komponenty

1. **Autentykacja**:
   - `auth_service.dart` - Serwis obsługujący logowanie, rejestrację i operacje na danych użytkowników
   - `gate.dart` - Komponent zarządzający stanem uwierzytelnienia użytkownika

2. **Interfejs użytkownika**:
   - `TabBar.dart` - Główny widok aplikacji z zakładkami
   - `homepage.dart` - Ekran główny z listą grup
   - `secondpage.dart` - Ekran z informacjami o płatnościach

3. **Komponenty funkcjonalne**:
   - `Grups.dart` - Komponent wyświetlający pojedynczą grupę
   - `friend_requests_screen.dart` - Ekran zarządzania zaproszeniami do znajomych
   - `search_friends_screen.dart` - Ekran wyszukiwania znajomych

4. **Pomocnicze**:
   - `button.dart` - Reużywalny komponent przycisku
   - `dialog_box.dart` - Okno dialogowe do tworzenia nowych grup

## Dokumentacja klas i metod

### `AuthService`

Klasa odpowiedzialna za komunikację z Supabase i zarządzanie użytkownikami.

#### Główne metody:

- `signInWithEmailPassword(String email, String password)` - Logowanie użytkownika
- `signUpWithEmailPassword(String email, String password)` - Rejestracja nowego użytkownika
- `signOut()` - Wylogowanie użytkownika
- `getCurrentUserId()` - Pobranie ID aktualnie zalogowanego użytkownika
- `searchUsers(String query)` - Wyszukiwanie użytkowników po nazwie
- `sendFriendRequest(String userId, String friendId)` - Wysłanie zaproszenia do znajomych
- `getFriends(String userId)` - Pobranie listy znajomych
- `getPendingFriendRequests(String userId)` - Pobranie oczekujących zaproszeń
- `acceptFriendRequest(int friendshipIdInt)` - Akceptacja zaproszenia
- `createGroup(String groupName)` - Tworzenie nowej grupy
- `addMemberToGroup(int groupId, String userId)` - Dodawanie członka do grupy
- `getUserGroups()` - Pobranie grup użytkownika
- `getGroupMembers(int groupId)` - Pobranie członków grupy
- `removeMemberFromGroup(int groupId, String userId)` - Usuwanie członka z grupy
- `deleteGroup(int groupId)` - Usuwanie grupy
- `getAmountToPay(String userId)` - Pobranie kwoty do zapłaty

### `AuthGate`

Komponent zarządzający stanem uwierzytelnienia użytkownika.

- Wyświetla ekran logowania (`LoginPage`) gdy użytkownik nie jest zalogowany
- Przekierowuje do głównego interfejsu (`Tabbar`) po zalogowaniu

### `Tabbar`

Główny interfejs aplikacji z zakładkami i menu bocznym.

#### Funkcje:

- Wyświetla dwie zakładki: "Friends Pay" i "You Pay"
- Zawiera menu boczne z:
  - Wyszukiwarką znajomych
  - Listą oczekujących zaproszeń
  - Listą aktualnych znajomych
- Przycisk wylogowania

### `HomePage`

Ekran główny aplikacji wyświetlający listę grup użytkownika.

#### Funkcje:

- Wyświetlanie listy grup
- Tworzenie nowych grup
- Usuwanie grup
- Dodawanie członków do grup

### `Grups`

Komponent reprezentujący pojedynczą grupę.

#### Właściwości:

- `GroupName` - Nazwa grupy
- `amount` - Kwota do zapłaty
- `groupId` - ID grupy w bazie danych
- `delateFunction` - Funkcja usuwająca grupę
- `onAddMember` - Funkcja dodająca członka do grupy

## Przepływ danych

1. **Uwierzytelnianie**:
   - Użytkownik loguje się przez `AuthService`
   - `AuthGate` przekierowuje do głównego interfejsu

2. **Zarządzanie grupami**:
   - Użytkownik tworzy grupę przez `HomePage`
   - Dane są zapisywane w Supabase przez `AuthService`
   - Członkowie są dodawani przez `addMemberToGroup`

3. **Zarządzanie znajomymi**:
   - Zaproszenia są wysyłane przez `search_friends_screen`
   - Zaproszenia są akceptowane przez `friend_requests_screen`
   - Lista znajomych jest pobierana przez `Tabbar`

## Wymagane tabele w Supabase

Aplikacja wymaga następujących tabel w Supabase:

1. `profiles` - Przechowuje informacje o użytkownikach
2. `friends` - Przechowuje relacje znajomości między użytkownikami
3. `groups` - Przechowuje informacje o grupach
4. `group_members` - Przechowuje relacje użytkowników z grupami
5. `user_debts` - Przechowuje informacje o należnościach

## Uruchomienie aplikacji

1. Zainicjalizuj Supabase z odpowiednimi danymi (anonKey i URL)
2. Upewnij się, że wszystkie wymagane tabele istnieją w Supabase
3. Uruchom aplikację przez `main.dart`

## Uwagi

- Aplikacja wykorzystuje temat jasny i ciemny (`lightmode` i `darkmode`)
- Wszystkie operacje na danych są asynchroniczne
- Komunikaty błędów są wyświetlane użytkownikowi przez `SnackBar`
- Stan aplikacji jest utrzymywany nawet przy przełączaniu między zakładkami dzięki `AutomaticKeepAliveClientMixin`
