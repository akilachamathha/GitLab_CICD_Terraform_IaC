import streamlit as st
import joblib
import numpy as np

st.title('Loan Prediction App - Demo')
st.write('Welcome to the Loan Prediction App. Please enter the details to get the predicted loan amount.')

# Get the user input
monthly_gross_income = st.number_input('Monthly GrossIncome (LKR)', 0.00, help='Enter your Monthly Gross Income')
taxable_income = st.number_input('Monthly TaxableIncome (LKR)', 0.00, help='Enter your Monthly Taxable Income')
nontaxable_income = st.number_input('Monthly NontaxableIncome (LKR)', 0.00, help='Enter your Monthly Nontaxable Income')
total_deduction = st.number_input('Monthly TotalDeduction (LKR)', 0.00, help='Enter your Monthly Total Deduction')
withholding_tax = st.number_input('Monthly WithholdingTax (LKR)', 0.00, help='Enter your Monthly Withholding Tax')
net_worth = st.number_input('NetWorth (LKR)', 0.00, help='Enter your Net Worth')
previous_loan_amount = st.number_input('PreviousLoanAmount (LKR)', 0.00, help='Enter the Previous Loan Amount')
loan_duration = st.number_input('Loan Duration (Month)', 0, help='Enter the Loan Duration in Months')
payment_history = st.number_input('Payment History (Month)', 0, help='Enter the Payment History in Months')
loan_interest = st.number_input('LoanInterest (%)', 0.00, 100.00, help='Enter the Loan Interest Rate')

gross_income = monthly_gross_income * 12
net_pay = monthly_gross_income - withholding_tax - total_deduction

entered_data = np.array([[gross_income, monthly_gross_income, taxable_income, nontaxable_income, total_deduction, withholding_tax, net_pay, net_worth, previous_loan_amount, loan_duration, payment_history, loan_interest]])


if(st.button('Predict')):
    if(gross_income<=0 or net_worth<=0):
        st.error('Please enter valid values. Gross Income and Net Worth should be greater than 0')
    else:
        # Load the trained model
        model = joblib.load('random_forest_model.pkl')

        # Get predictions from the model
        prediction = model.predict(entered_data)

        # Display the predicted loan amount
        st.write('The predicted loan amount is:', prediction[0], 'LKR')
        print("Prediction:", prediction[0])
