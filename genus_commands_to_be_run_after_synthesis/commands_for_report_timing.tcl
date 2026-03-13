echo "1.timing_report_in2reg.rpt ="
cat 1.timing_report_in2reg.rpt | grep "Path " | wc

echo "2.timing_report_reg2reg.rpt ="
cat 2.timing_report_reg2reg.rpt | grep "Path " | wc

echo "3.timing_report_reg2out.rpt ="
cat 3.timing_report_reg2out.rpt | grep "Path " | wc

echo "4.timing_report_in2out.rpt ="
cat 4.timing_report_in2out.rpt | grep "Path " | wc


#echo grep for path
echo "======================================================================================"
echo "1.timing_report_in2reg.rpt ="
echo "======================================================================================"
cat 1.timing_report_in2reg.rpt | grep "Path "


echo "======================================================================================"
echo "2.timing_report_reg2reg.rpt ="
echo "======================================================================================"
cat 2.timing_report_reg2reg.rpt | grep "Path "


echo "======================================================================================"
echo "3.timing_report_reg2out.rpt ="
echo "======================================================================================"
cat 3.timing_report_reg2out.rpt | grep "Path "


echo "======================================================================================"
echo "4.timing_report_in2out.rpt ="
echo "======================================================================================"
cat 4.timing_report_in2out.rpt | grep "Path "


echo "======================================================================================"
echo "Done"
echo "======================================================================================"


#echo grep for Slack
echo "======================================================================================"
echo "1.timing_report_in2reg.rpt ="
echo "======================================================================================"
cat 1.timing_report_in2reg.rpt | grep "Slack:=" > 1.timing_report_in2reg_slack.rpt


echo "======================================================================================"
echo "2.timing_report_reg2reg.rpt ="
echo "======================================================================================"
cat 2.timing_report_reg2reg.rpt | grep "Slack:=" > 2.timing_report_reg2reg_slack.rpt


echo "======================================================================================"
echo "3.timing_report_reg2out.rpt ="
echo "======================================================================================"
cat 3.timing_report_reg2out.rpt | grep "Slack:=" > 3.timing_report_reg2out_slack.rpt


echo "======================================================================================"
echo "4.timing_report_in2out.rpt ="
echo "======================================================================================"
cat 4.timing_report_in2out.rpt | grep "Slack:=" > 4.timing_report_in2out_slack.rpt


echo "======================================================================================"
echo "Done"
echo "======================================================================================"
