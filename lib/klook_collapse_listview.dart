import 'package:flutter/material.dart';
import 'klook_collapse_title.dart';
import 'widget_util.dart';

class CarRentalQuestionListView extends StatelessWidget {
  const CarRentalQuestionListView(
      List<QuestionModel> faqs, {
        Key key,
        String helpCenterText,
        VoidCallback onTapHelpCenter,
        Function(bool, QuestionModel) onExpansionChanged,
      })  : _faqs = faqs,
        _onTapHelpCenter = onTapHelpCenter,
        _helpCenterText = helpCenterText,
        _onExpansionChanged = onExpansionChanged,
        super(key: key);

  final List<QuestionModel> _faqs;
  final String _helpCenterText;
  final VoidCallback _onTapHelpCenter;
  final Function(bool, QuestionModel) _onExpansionChanged;

  @override
  Widget build(BuildContext context) {

    return Container(
      color: ColorUtil.BW10,
      child: Column(
        children: <Widget>[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _faqs.length,
            itemBuilder: (_, index) {
              return _buildItems(_faqs[index], index);
            },
            separatorBuilder: (_, index) {
              return const Divider(
                height: 1,
                thickness: 1,
                color: ColorUtil.BW8,
                indent: 16,
                endIndent: 16,
              );
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: ColorUtil.BW8,
          ),
          GestureDetector(
            onTap: _onTapHelpCenter,
            behavior: HitTestBehavior.opaque,
            child: Container(
              alignment: Alignment.center,
              height: 48,
              width: double.infinity,
              child: Text(
                _helpCenterText ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorUtil.BW1,
                  fontWeight: FontWeightUtil.semibold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItems(QuestionModel faq, int index) {
    int currentIndex = -1;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CarRentalQuestionExpansionTile(

          index: index,
          onExpansionChanged: (state) {
            if (_onExpansionChanged != null) {
              _onExpansionChanged(state, faq);
            }
          },
          onExpansionClick: (index){
             currentIndex = index;
            debugPrint("currentIndex: $index");
          },
          initiallyExpanded: currentIndex == index ? true : false,
          key: PageStorageKey<QuestionModel>(faq),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              faq.question,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: ColorUtil.BW1,
              ),
            ),
          ),
//          trailing: SvgPicture.asset(
//            CommonAssets.icon_expandmore,
//            package: CommonAssets.package,
//            width: 24,
//            height: 24,
//          ),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: ColorUtil.BW8,
              ),
              child: Text(
                faq.anwser,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: ColorUtil.BW2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 接口未确定，临时创建的model
class QuestionModel {
  const QuestionModel({this.question, this.anwser, this.isOpen = false});
  final String question;
  final String anwser;
  final bool isOpen;
}
