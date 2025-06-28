import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigapp/core/infrastructure/ui/utils/colors_utils.dart';
import 'package:sigapp/core/infrastructure/utils/time_utils.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule/course_visibility_cubit.dart';

class EventWidget extends StatelessWidget {
  final WeeklyScheduleWidgetItem event;
  final BoxConstraints constraints;
  final List<int> daysWithEvents;
  final int startHour;
  final double fontSize;
  final double rowHeight;
  final double hourWidth;
  final Function(WeeklyScheduleWidgetItem)? onTap;

  const EventWidget({
    super.key,
    required this.event,
    required this.constraints,
    required this.daysWithEvents,
    required this.startHour,
    required this.fontSize,
    required this.rowHeight,
    required this.hourWidth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseVisibilityCubit, CourseVisibilityState>(
      builder: (context, state) {
        final adaptiveScaleFactor = MediaQuery.of(context).size.width * 0.0013;
        final isHidden = state.hiddenEvents[event.eventId] ?? event.isHidden;

        // Nueva lógica para manejar eventos ocultos
        final Color displayColor = isHidden ? Colors.transparent : event.color;
        final Color textColor =
            isHidden ? Colors.grey : ColorsUtils.getTextColor(event.color);
        final Border? border =
            isHidden ? Border.all(color: Colors.grey, width: 1.0) : null;

        // Definir el ancho del borde para usarlo en los cálculos
        final borderWidth = isHidden ? 1.0 : 0.0;

        // Calcular dimensiones de posicionamiento
        final positionData = _calculatePositionData();

        // Calcular tamaños de fuente y medidas de texto
        final textMeasures = _calculateTextMeasures(adaptiveScaleFactor);

        // Calcular espacios y paddings
        final layoutMeasures = _calculateLayoutMeasures(textMeasures);

        // Calcular dimensiones de contenido teniendo en cuenta el borde
        final contentMeasures = _calculateContentDimensions(
          positionData.height,
          layoutMeasures,
          textMeasures,
          borderWidth,
        );

        // Determinar si mostrar captions basado en el espacio disponible
        final shouldShowCaptions =
            isHidden
                ? (contentMeasures.captionsCanBeShown &&
                    contentMeasures.availableHeightForTitle >
                        textMeasures.titleOneLineHeight * 1.2)
                : contentMeasures.captionsCanBeShown;

        return Positioned(
          top: positionData.top,
          left: positionData.left,
          width: positionData.width,
          height: positionData.height,
          child: GestureDetector(
            onTap: onTap != null ? () => onTap!(event) : null,
            child: Container(
              decoration: BoxDecoration(
                color: displayColor,
                borderRadius: BorderRadius.circular(
                  layoutMeasures.verticalPadding,
                ),
                border: border,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: layoutMeasures.verticalPadding,
                  horizontal: layoutMeasures.horizontalPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTitleSection(
                      textColor,
                      textMeasures,
                      contentMeasures,
                    ),
                    if (shouldShowCaptions)
                      _buildCaptionsSection(
                        textColor,
                        textMeasures,
                        contentMeasures.availableWidth,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Calcula las dimensiones y posición del evento en la cuadrícula
  _PositionData _calculatePositionData() {
    final top =
        (event.data.startHour - startHour) * rowHeight +
        (event.data.startMinutes / 60) * rowHeight;

    final gridWidth =
        (constraints.maxWidth - hourWidth) / daysWithEvents.length;
    final sideMargin = gridWidth * 0.05;
    final width = gridWidth - sideMargin;

    final dayIndex = daysWithEvents.indexOf(event.data.weekday);
    final left = hourWidth + dayIndex * gridWidth;

    final height =
        ((event.data.endHour - event.data.startHour) * rowHeight +
            ((event.data.endMinutes - event.data.startMinutes) / 60) *
                rowHeight) -
        sideMargin;

    return _PositionData(top: top, left: left, width: width, height: height);
  }

  /// Calcula las medidas relacionadas con el texto y fuentes
  _TextMeasures _calculateTextMeasures(double adaptiveScaleFactor) {
    final titleFontSize = fontSize * adaptiveScaleFactor * 1.9;
    const titleLineHeight = 1.1;
    final titleOneLineHeight = titleFontSize * titleLineHeight;

    final captionFontSize = fontSize * adaptiveScaleFactor * 1.4;
    const captionLineHeight = 1.2;
    final captionOneLineHeight = captionFontSize * captionLineHeight;

    return _TextMeasures(
      titleFontSize: titleFontSize,
      titleLineHeight: titleLineHeight,
      titleOneLineHeight: titleOneLineHeight,
      captionFontSize: captionFontSize,
      captionLineHeight: captionLineHeight,
      captionOneLineHeight: captionOneLineHeight,
    );
  }

  /// Calcula espacios y paddings para el layout
  _LayoutMeasures _calculateLayoutMeasures(_TextMeasures textMeasures) {
    final verticalPadding = textMeasures.titleFontSize / 2;
    final horizontalPadding = textMeasures.titleFontSize / 3;
    final separatorSpace = textMeasures.captionOneLineHeight * 0.5;
    final captionsHeight =
        textMeasures.captionOneLineHeight * 2; // Para location y duration

    return _LayoutMeasures(
      verticalPadding: verticalPadding,
      horizontalPadding: horizontalPadding,
      separatorSpace: separatorSpace,
      captionsHeight: captionsHeight,
    );
  }

  /// Calcula las dimensiones del contenido basado en el espacio disponible
  _ContentMeasures _calculateContentDimensions(
    double height,
    _LayoutMeasures layoutMeasures,
    _TextMeasures textMeasures, [
    double borderWidth = 0.0,
  ]) {
    // Ajustar el espacio disponible considerando el borde
    final availableHeight =
        height - (layoutMeasures.verticalPadding * 2) - (borderWidth * 2);
    final availableWidth =
        _calculatePositionData().width -
        (layoutMeasures.horizontalPadding * 2) -
        (borderWidth * 2);

    // Determinar si hay espacio para mostrar las leyendas
    final captionsCanBeShown =
        availableHeight >
        (textMeasures.titleOneLineHeight +
            layoutMeasures.separatorSpace +
            layoutMeasures.captionsHeight);

    // Calcular espacio disponible para el título
    var availableHeightForTitle = availableHeight;
    if (captionsCanBeShown) {
      availableHeightForTitle -=
          layoutMeasures.separatorSpace + layoutMeasures.captionsHeight;
    }

    // Calcular número máximo de líneas para el título
    final safetyMargin = textMeasures.titleOneLineHeight * 0.15;
    final titleMaxLines =
        ((availableHeightForTitle - safetyMargin) /
                textMeasures.titleOneLineHeight)
            .floor();
    final finalTitleMaxLines = titleMaxLines > 0 ? titleMaxLines : 1;

    return _ContentMeasures(
      availableWidth: availableWidth,
      availableHeightForTitle: availableHeightForTitle,
      captionsCanBeShown: captionsCanBeShown,
      titleMaxLines: finalTitleMaxLines,
    );
  }

  /// Construye la sección del título
  Widget _buildTitleSection(
    Color textColor,
    _TextMeasures textMeasures,
    _ContentMeasures contentMeasures,
  ) {
    return SizedBox(
      height: contentMeasures.availableHeightForTitle,
      width: contentMeasures.availableWidth,
      child: Text(
        event.data.courseName,
        style: TextStyle(
          color: textColor,
          fontSize: textMeasures.titleFontSize,
          height: textMeasures.titleLineHeight,
          fontWeight: FontWeight.bold,
        ),
        maxLines: contentMeasures.titleMaxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Construye la sección de leyendas (ubicación y duración)
  Widget _buildCaptionsSection(
    Color textColor,
    _TextMeasures textMeasures,
    double availableWidth,
  ) {
    return SizedBox(
      width: availableWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.data.location,
            style: TextStyle(
              color: textColor,
              fontSize: textMeasures.captionFontSize,
              height: textMeasures.captionLineHeight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            TimeUtils.formatEventDuration(
              EventDuration(
                startHour: event.data.startHour,
                startMinute: event.data.startMinutes,
                endHour: event.data.endHour,
                endMinute: event.data.endMinutes,
              ),
            ),
            style: TextStyle(
              color: textColor,
              fontSize: textMeasures.captionFontSize,
              height: textMeasures.captionLineHeight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Clase para almacenar datos de posicionamiento
class _PositionData {
  final double top;
  final double left;
  final double width;
  final double height;

  _PositionData({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });
}

/// Clase para almacenar medidas relacionadas con el texto
class _TextMeasures {
  final double titleFontSize;
  final double titleLineHeight;
  final double titleOneLineHeight;
  final double captionFontSize;
  final double captionLineHeight;
  final double captionOneLineHeight;

  _TextMeasures({
    required this.titleFontSize,
    required this.titleLineHeight,
    required this.titleOneLineHeight,
    required this.captionFontSize,
    required this.captionLineHeight,
    required this.captionOneLineHeight,
  });
}

/// Clase para almacenar medidas de layout
class _LayoutMeasures {
  final double verticalPadding;
  final double horizontalPadding;
  final double separatorSpace;
  final double captionsHeight;

  _LayoutMeasures({
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.separatorSpace,
    required this.captionsHeight,
  });
}

/// Clase para almacenar medidas de contenido
class _ContentMeasures {
  final double availableWidth;
  final double availableHeightForTitle;
  final bool captionsCanBeShown;
  final int titleMaxLines;

  _ContentMeasures({
    required this.availableWidth,
    required this.availableHeightForTitle,
    required this.captionsCanBeShown,
    required this.titleMaxLines,
  });
}
