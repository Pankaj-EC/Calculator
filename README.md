# Gujarati Voice Calculator

A simple and elegant calculator app with support for both English and Gujarati languages. The app includes voice feedback and a history of calculations.

## Features

- Basic arithmetic operations: addition, subtraction, multiplication, and division.
- Support for percentage calculations.
- Support for complex expressions, such as `(1+3) × 2`.
- Toggle between English and Gujarati numeral systems.
- Voice feedback in both English and Gujarati.
- History of calculations with the ability to clear the history.
- Dark theme for comfortable usage.

## Screenshots

![App View](assets/AppView.PNG)

## Installation

To run this project locally, follow these steps:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Pankaj-EC/Calculator.git
   cd Calculator

2. **Install dependencies:**
   ```bash
   flutter pub get

3. **Run the app:**
   ```bash
   flutter run

4. **Export app:**
   ```bash
   flutter build apk --release
then find App in : build\app\outputs\flutter-apk\Calculator.apk


## Dependencies

- flutter_tts: For text-to-speech functionality.
- math_expressions: For parsing and evaluating mathematical expressions.

## Usage
- Switch Language: Use the toggle switch in the top-right corner to switch between English and Gujarati.
- Sound On/Off: Use the sound icon in the app bar to enable or disable voice feedback.
- Clear History: Use the clear button in the history section to remove all previous calculations.
- Backspace: Use the backspace icon to delete the last character in the current input.
- Calculate: Enter your expression and press = to see the result.

## Code Overview
### Main File
The main file main.dart contains the following components:

- MyApp: The root widget of the application.
- Calculator: The stateful widget containing the main logic and UI of the calculator.
- ButtonPressed Function: Handles the logic for different button presses.
- History Section: Displays the history of calculations.

## Calculator Logic
The calculator logic supports basic arithmetic operations, percentage calculations, and complex expressions. The math_expressions package is used to parse and evaluate expressions, allowing for complex calculations.

## Voice Feedback
The app uses the flutter_tts package to provide voice feedback in the selected language (English or Gujarati). The voice feedback is triggered upon pressing the = button.

## Contributing
Feel free to submit issues and enhancement requests. If you'd like to contribute, please fork the repository and use a feature branch. Pull requests are welcome.