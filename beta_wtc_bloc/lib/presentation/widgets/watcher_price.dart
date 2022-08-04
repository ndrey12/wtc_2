import 'package:beta_wtc_bloc/logic/cubit/coin_price_cubit.dart';
import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatcherPriceWidget extends StatefulWidget {
  String coinName;
  String coinPrice = "1000.0";
  int lines;
  int columns;
  WatcherPriceWidget(
      {Key? key,
      required this.coinName,
      required this.lines,
      required this.columns})
      : super(key: key);

  @override
  State<WatcherPriceWidget> createState() => _WatcherPriceWidgetState();
}

class _WatcherPriceWidgetState extends State<WatcherPriceWidget> {
  String removeTrailingZeros(String n) {
    return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocConsumer<CoinPriceCubit, CoinPriceState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.coinPrices[widget.coinName] != null &&
                state.coinPrices[widget.coinName]!.isNotEmpty) {
              String newPrice = state.coinPrices[widget.coinName].toString();

              newPrice = removeTrailingZeros(newPrice);
              widget.coinPrice = newPrice;
            }
            var appBarSize = AppBar().preferredSize.height;
            debugPrint(widget.lines.toString());
            debugPrint(MediaQuery.of(context).size.height.toString());
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / widget.columns,
                      height: (MediaQuery.of(context).size.height -
                              appBarSize * widget.lines -
                              appBarSize) /
                          widget.lines,
                      child: Center(
                        child: Stack(
                          children: [
                            AutoSizeText(
                              widget.coinPrice,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 3
                                  ..color = const Color(0xFF222222),
                              ),
                              maxLines: 1,
                              presetFontSizes: const [
                                250,
                                240,
                                230,
                                220,
                                210,
                                200,
                                190,
                                180,
                                160,
                                150,
                                140,
                                130,
                                120,
                                100,
                                90,
                                80,
                                70,
                                60,
                                50,
                                40,
                                30,
                                20,
                                10,
                                8,
                                5,
                                4,
                                3,
                                2,
                                1
                              ],
                            ),

                            // Solid text as fill.
                            AutoSizeText(
                              widget.coinPrice,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF847968),
                              ),
                              maxLines: 1,
                              presetFontSizes: const [
                                250,
                                240,
                                230,
                                220,
                                210,
                                200,
                                190,
                                180,
                                160,
                                150,
                                140,
                                130,
                                120,
                                100,
                                90,
                                80,
                                70,
                                60,
                                50,
                                40,
                                30,
                                20,
                                10,
                                8,
                                5,
                                4,
                                3,
                                2,
                                1
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //iconPrice,
              ],
            );
          },
        ),
      ],
    );
  }
}
