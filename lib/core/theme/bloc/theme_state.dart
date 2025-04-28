part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final Brightness brightness;

  const ThemeState({required this.brightness});

  bool get isDark => brightness == Brightness.dark;

  @override
  List<Object?> get props => [brightness];
}
