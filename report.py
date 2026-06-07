import matplotlib
matplotlib.use('Agg') # Enforce headless non-interactive system render pipeline execution
import matplotlib.pyplot as plt
import numpy as np
import os

def generate_hifz_analytics_chart(student_id: int, weeks: list, fluency_history: list, output_directory: str) -> str:
    """Generates structural progress visualization charts for dashboards using corporate colors."""
    
    # Initialize explicit aesthetic structural plot variables
    plt.figure(figsize=(8, 4))
    
    # Configure institutional design system palette coordinates
    emerald_green = "#0F5132"
    deep_slate = "#1E293B"
    gold_accent = "#D4AF37"
    
    # Map progress plots
    plt.plot(weeks, fluency_history, marker='o', color=emerald_green, linewidth=2.5, label="Fluency Index")
    plt.axhline(y=90.0, color=gold_accent, linestyle='--', alpha=0.7, label="Elite Target Threshold")
    
    # Set structural chart decorations
    plt.title(f"Hifz Progression Analysis - Student Context ID: {student_id}", fontdict={'fontsize': 14, 'color': deep_slate, 'weight': 'bold'})
    plt.xlabel("Academic Tracking Assessment Weeks", fontdict={'fontsize': 11})
    plt.ylabel("Accuracy / Tajweed Alignment Score (%)", fontdict={'fontsize': 11})
    plt.ylim(50, 105)
    plt.grid(True, linestyle=':', alpha=0.6)
    plt.legend(loc="lower right")
    
    # Ensure system write target directory boundaries exist cleanly
    os.makedirs(output_directory, exist_ok=True)
    target_filename = f"chart_student_{student_id}.png"
    target_file_path = os.path.join(output_directory, target_filename)
    
    # Save chart asset to the file repository
    plt.tight_layout()
    plt.savefig(target_file_path, dpi=150, facecolor='#FFFFFF')
    plt.close()
    
    return target_file_path
