import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus
import os


# 1. File Path (Using raw string for safety)
RAW_FILE_PATH = r"D:\Data Analytics Projects\Full fledge\customer-shopping-behavior-analysis-python-sql-powerbi\data\customer_shopping_behavior_raw.csv"

# 2. SQL Server Config
SERVER_NAME = r"MDSHAMIM\SQLEXPRESS"
DB_NAME = "RetailDB"
TABLE_NAME = "retail_sales_clean"

def extract(file_path):
    print("\n[STEP 1] EXTRACTING data...")
    print(f"   - Source: {file_path}")
    
    if not os.path.exists(file_path):
        print("   [ERROR] File NOT found!")
        print("   Please check if the file name is exactly 'customer_shopping_behavior_raw.csv'")
        return None
        
    try:
        df = pd.read_csv(file_path)
        print(f"   [SUCCESS] Loaded {len(df)} rows.")
        return df
    except Exception as e:
        print(f"   [ERROR] Extract failed: {e}")
        return None

def transform(df):
    print("[STEP 2] TRANSFORMING data...")
    
    # 1. Clean Column Headers
    df.columns = df.columns.str.lower().str.replace(' ', '_').str.replace('(', '').str.replace(')', '')
    
    # 2. Impute Missing Ratings
    if 'review_rating' in df.columns:
        df['review_rating'] = df.groupby('category')['review_rating'].transform(lambda x: x.fillna(x.median()))

    # 3. Standardize Frequency Text
    if 'frequency_of_purchases' in df.columns:
        freq_map = {'Bi-Weekly': 'Fortnightly', 'Every 3 Months': 'Quarterly'}
        df['frequency_of_purchases'] = df['frequency_of_purchases'].replace(freq_map)

    # 4. Feature Engineering: Frequency Days
    if 'frequency_of_purchases' in df.columns:
        days_map = {'Fortnightly': 14, 'Weekly': 7, 'Monthly': 30, 'Quarterly': 90, 'Annually': 365}
        df['frequency_days'] = df['frequency_of_purchases'].map(days_map)

    # 5. Feature Engineering: Age Group
    if 'age' in df.columns:
        labels = ['Young Adult', 'Adult', 'Middle-aged', 'Senior']
        df['age_group'] = pd.qcut(df['age'], q=4, labels=labels)

    # 6. Drop Redundant Columns
    if 'promo_code_used' in df.columns:
        df.drop(columns=['promo_code_used'], inplace=True)

    # 7. Parse Dates
    if 'transaction_date' in df.columns:
        df['transaction_date'] = pd.to_datetime(df['transaction_date'])

    print("   [SUCCESS] Data cleaned and features created.")
    return df

def load(df, table_name):
    print(f"[STEP 3] LOADING data into SQL Server table '{table_name}'...")
    
    try:
        # Connection String
        conn_str = (
            f"DRIVER={{ODBC Driver 17 for SQL Server}};"
            f"SERVER={SERVER_NAME};"
            f"DATABASE={DB_NAME};"
            f"Trusted_Connection=yes;"
        )
        quoted = quote_plus(conn_str)
        engine = create_engine(f"mssql+pyodbc:///?odbc_connect={quoted}")
        
        # Write to SQL
        df.to_sql(table_name, engine, if_exists='replace', index=False)
        print(f"   [SUCCESS] Pipeline Complete. Data loaded into SQL.")
        
    except Exception as e:
        print(f"   [ERROR] Load failed: {e}")

if __name__ == "__main__":
    print("--- STARTING PIPELINE ---")
    data = extract(RAW_FILE_PATH)
    if data is not None:
        clean_data = transform(data)
        load(clean_data, TABLE_NAME)
    else:
        print("--- PIPELINE STOPPED (Check File Path) ---")