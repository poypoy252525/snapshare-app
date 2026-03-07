import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationState {
  final double progress; // 0.0 = fully visible, 1.0 = fully hidden
  final bool animate;

  NavigationState(this.progress, {this.animate = false});
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(0.0));

  void updateOffset(double delta, double maxOffset) {
    if (maxOffset <= 0) return;

    // delta > 0 is scrolling down (hiding), delta < 0 is scrolling up (showing)
    final double change = delta / maxOffset;
    final double newProgress = (state.progress + change).clamp(0.0, 1.0);

    if (newProgress != state.progress || state.animate) {
      emit(NavigationState(newProgress, animate: false));
    }
  }

  void snap() {
    if (state.progress == 0.0 || state.progress == 1.0) return;

    final double targetProgress = state.progress > 0.5 ? 1.0 : 0.0;
    emit(NavigationState(targetProgress, animate: true));
  }

  void show() => emit(NavigationState(0.0, animate: true));
  void hide() => emit(NavigationState(1.0, animate: true));
}
