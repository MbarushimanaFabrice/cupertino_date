# Cupertino Date Picker Demo

A Flutter demo showing how the `CupertinoDatePicker` widget handles dates, times, and date-time values in a polished employee scheduling interface.

## UI screenshots

### Schedule date picker

![Schedule date picker](images/Screenshot%202026-10-12%20143611.jpg)

### Updated schedule overview

![Updated schedule overview](images/Screenshot%202026-10-12%20143626.jpg)

### Cupertino picker examples

![Cupertino picker examples](images/Screenshot%202026-10-12%20143633.jpg)

## Run the app

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Clone this repository and open the project directory:

   ```bash
   git clone https://github.com/MbarushimanaFabrice/cupertino_date.git
   cd cupertino_date
   ```

3. Install dependencies and launch the app:

   ```bash
   flutter pub get
   flutter run
   ```

## Important `CupertinoDatePicker` attributes

- `mode` chooses whether the wheel selects a date, a time, or both.
- `initialDateTime` sets the value shown when the picker opens.
- `onDateTimeChanged` receives every wheel change so the screen can update immediately.

The demo also includes an employee schedule screen that uses the selected date and team filter to show matching shifts.
