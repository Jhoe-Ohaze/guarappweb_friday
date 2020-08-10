class EncodeData
{
  static String ConvertYear(int year)
  {
    switch(year)
    {
      case 2020: return 'a';
      case 2021: return 'b';
      case 2022: return 'c';
      case 2023: return 'd';
      case 2024: return 'e';
      case 2025: return 'f';
      case 2026: return 'g';
    }
  }

  static String ConvertMonth(int month)
  {
    switch(month)
    {
      case 1: return 'a';
      case 2: return 'b';
      case 3: return 'c';
      case 4: return 'd';
      case 5: return 'e';
      case 6: return 'f';
      case 7: return 'g';
      case 8: return 'h';
      case 9: return 'i';
      case 10: return 'j';
      case 11: return 'k';
      case 12: return 'l';
    }
  }
  
  static String ConvertDay(int day)
  {
    return day.toRadixString(32);
  }
}