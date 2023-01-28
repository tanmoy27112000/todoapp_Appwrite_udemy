RegExp emailRegex = RegExp(
  r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  caseSensitive: false,
);

RegExp passwordRegex = RegExp(
  r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  caseSensitive: false,
);
