import numpy as np
import pandas as pd
import os

class AcademicMetricsEngine:
    def __init__(self, tenant_storage_root: str):
        self.storage_root = tenant_storage_root

    def evaluate_term_report_cards(self, performance_matrix_csv: str) -> dict:
        """Processes weighted student performance data while preventing division-by-zero errors."""
        if not os.path.exists(performance_matrix_csv):
            return {"status": "FAILED", "reason": "Data ingestion file path missing."}

        # Load performance structure array into memory
        df = pd.read_csv(performance_matrix_csv)
        
        # Structure Expectations: ['student_id', 'quizzes', 'assignments', 'finals', 'hifz_fluency']
        required_columns = ['student_id', 'quizzes', 'assignments', 'finals', 'hifz_fluency']
        if not all(col in df.columns for col in required_columns):
            return {"status": "FAILED", "reason": "Structural schema mismatch on raw import variables."}

        # Defensive handling for incomplete records: Impute missing numerical fields with a safe zero boundary
        df.fillna({'quizzes': 0.0, 'assignments': 0.0, 'finals': 0.0, 'hifz_fluency': 0.0}, inplace=True)

        # Convert data frames into vectorized NumPy arrays for mathematical evaluation running pipelines
        quiz_array = df['quizzes'].to_numpy()
        assignment_array = df['assignments'].to_numpy()
        finals_array = df['finals'].to_numpy()

        # Weight distribution variables configuration
        w_quiz, w_assign, w_final = 0.20, 0.30, 0.50

        # Matrix dot product array pipeline execution mapping
        calculated_final_scores = (quiz_array * w_quiz) + (assignment_array * w_assign) + (finals_array * w_final)
        df['weighted_academic_total'] = calculated_final_scores

        # Package analytical aggregate states for system export configurations
        summary_payload = {}
        for index, row in df.iterrows():
            st_id = int(row['student_id'])
            summary_payload[st_id] = {
                "academic_score": float(np.round(row['weighted_academic_total'], 2)),
                "hifz_fluency": float(np.round(row['hifz_fluency'], 2)),
                "status": "PASS" if row['weighted_academic_total'] >= 50.0 else "REMEDIATION_REQUIRED"
            }

        return {"status": "SUCCESS", "metrics": summary_payload}
