import pandas as pd
import os


def validate_sales_data(file_path):
    """Validate and auto-clean sales data, always saving cleaned version."""
    try:
        # Load data
        df = pd.read_csv(file_path)

        # Verify critical columns exist
        required_columns = ['Total_Sales', 'Revenue', 'Total_Units_Sold']
        missing_cols = [col for col in required_columns if col not in df.columns]
        if missing_cols:
            raise KeyError(f"Missing columns: {missing_cols}")

        # --- AUTO-FIX MISSING VALUES ---
        df['Total_Sales'] = df['Total_Sales'].fillna(0)  # Fill missing sales with 0
        df['Revenue'] = df['Revenue'].fillna(0)  # Fill missing revenue with 0

        # --- VALIDATION CHECKS ---
        errors = []

        # Check for negative values
        if (df['Total_Sales'] < 0).any():
            errors.append(f"{sum(df['Total_Sales'] < 0)} negative sales")

        if (df['Total_Units_Sold'] <= 0).any():
            errors.append(f"{sum(df['Total_Units_Sold'] <= 0)} invalid unit counts")

        # --- ALWAYS SAVE CLEANED DATA ---
        output_path = os.path.join(os.path.dirname(file_path), 'sales_data_clean_final.csv')
        df.to_csv(output_path, index=False)
        print(f"Cleaned data saved to: {output_path}")

        # --- RESULTS ---
        if errors:
            print("Validation warnings (auto-fixed issues):")
            for error in errors:
                print(f"- {error}")
            return False
        else:
            print("Data is clean!")
            return True

    except Exception as e:
        print(f"Critical error: {str(e)}")
        if 'df' in locals():
            print("Columns detected:", df.columns.tolist())
        return False


if __name__ == "__main__":
    # Print where the file will be saved
    script_dir = os.path.dirname(os.path.abspath(__file__))
    print(f"Cleaned file will be saved in: {script_dir}")

    validate_sales_data('sales_data_clean.csv')