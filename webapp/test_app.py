from streamlit.testing.v1 import AppTest

def test_loan_prediction_ui_valid_inputs():
    at = AppTest.from_file("app.py")
    at.run(timeout=10)

    # Set values in the order they appear in your app
    at.number_input[0].set_value(50000)  # Monthly GrossIncome
    at.number_input[1].set_value(40000)  # Monthly TaxableIncome
    at.number_input[2].set_value(10000)  # Monthly NontaxableIncome
    at.number_input[3].set_value(5000)   # Monthly TotalDeduction
    at.number_input[4].set_value(1000)   # Monthly WithholdingTax
    at.number_input[5].set_value(200000) # NetWorth
    at.number_input[6].set_value(50000)  # PreviousLoanAmount
    at.number_input[7].set_value(24)     # Loan Duration (Months)
    at.number_input[8].set_value(12)     # Payment History (Months)
    at.number_input[9].set_value(10.0)   # LoanInterest (%)

    at.button[0].click()
    at.run(timeout=10)

    # Now you can assert something, e.g. prediction output exists
    assert any("The predicted loan amount is:" in e.value for e in at.markdown)


