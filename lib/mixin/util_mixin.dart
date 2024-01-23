import 'package:flutter/cupertino.dart';

mixin utilMixin {
  jumpScrollPositionToTop(ScrollController scrollController) =>
      scrollController.jumpTo(0);
}
