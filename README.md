# UNESP_Yamatec

This project is a research project created for a master's degree at UNESP University. The goal of the project is to predict the incidence of leakages in water distribution systems by analyzing pressure sensors along the water supply network. 

The project makes use of a Gated Graph Neural Network (GGNN) to receive the data and predict if there is a leakage. Before using the data to train the model, a data preprocessing step is performed using the `preprocess14.py` or `preprocess16.py` script to make the dataset more suitable for use.

## Installation

Before running the project, you will need to install the required dependencies listed in the requirements.txt file. You will also need to have the necessary data files available.

## Usage

1. Run the `preprocess14.py` or `preprocess16.py` script to preprocess the data.
2. Open the `Testes dist maior.ipynb` file in a Jupyter Notebook environment or similar software.
3. Follow the instructions in the notebook to load the preprocessed data and train the GGNN model.
4. Use the trained model to predict the incidence of leakages in water distribution systems.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## Acknowledgments

This project was developed for a master's degree at UNESP University and incorporates machine learning and data preprocessing techniques.
