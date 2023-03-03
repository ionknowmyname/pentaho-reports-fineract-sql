select concat(repeat("..",   
   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, '.', '')) - 1))), ounder.`name`) as "Office/Branch",ounder.name, ounder.id,
ifnull(cur.display_symbol, l.currency_code) as Currency,
ifnull(lo.`display_name`,'-') as "Loan Officer", 
c.display_name as "Client", 
l.account_no as "Loan Account No.",
ifnull(pl.`name`,'-') as "Product", 
ifnull(f.`name`,'-') as Fund,  
ifnull(l.`principal_amount`,0) as "Loan Amount", 
ifnull(l.`annual_nominal_interest_rate`,0)as "Annual Nominal Interest Rate", 
date(l.disbursedon_date) as "Disbursed Date", 
date(l.expected_maturedon_date) as "Expected Matured On",

ifnull(l.`principal_repaid_derived`,0) as "Principal Repaid",
ifnull(l.`principal_outstanding_derived`,0) as "Principal Outstanding",
ifnull(laa.`principal_overdue_derived`,0) as "Principal Overdue",

ifnull(l.`interest_repaid_derived`,0.00) as "Interest Repaid",
ifnull(l.`interest_outstanding_derived`,0) as "Interest Outstanding",
ifnull(laa.`interest_overdue_derived`,0) as "Interest Overdue",

ifnull(l.`fee_charges_repaid_derived`,0) as "Fees Repaid",
ifnull(l.`fee_charges_outstanding_derived`,0)  as "Fees Outstanding",
ifnull(laa.`fee_charges_overdue_derived`,0) as "Fees Overdue",

ifnull(l.`penalty_charges_repaid_derived`,0) as "Penalties Repaid",
ifnull(l.`penalty_charges_outstanding_derived` ,0)as "Penalties Outstanding",
ifnull(penalty_charges_overdue_derived,0) as "Penalties Overdue" 

from m_office o 
join m_office ounder on ounder.hierarchy like concat(o.hierarchy, '%') 
and ounder.hierarchy like concat(${userhierarchy}, '%') 
join m_client c on c.office_id = ounder.id 
join m_loan l on l.client_id = c.id 
join m_product_loan pl on pl.id = l.product_id 
left join m_staff lo on lo.id = l.loan_officer_id 
left join m_currency cur on cur.code = l.currency_code 
left join m_fund f on f.id = l.fund_id 
left join m_loan_arrears_aging laa on laa.loan_id = l.id 

where o.id = ${branch} 
and (ifnull(l.loan_officer_id, -10) = ${loanOfficer} or "-1" = ${loanOfficer}) 
and (l.currency_code = ${currencyId} or "-1" = ${currencyId}) 
and (l.product_id = ${loanProductId} or "-1" = ${loanProductId}) 
and (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId}) 
and (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or "-1" = ${loanPurposeId}) 
and l.loan_status_id = 300 

group by l.id                                                                        