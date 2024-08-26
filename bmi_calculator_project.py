
#Process
#1. input height and weight
#2. Set up BMI calcuation, and round for ease
#3. Group BMI values into different classifications and print outcome

weight = float(input('Enter your weight in pounds: '))

height = float(input('Enter your weight in inches: '))

BMI = (weight * 703) / (height * height)

Rounded_BMI = round(BMI, 1)

print('\nYour BMI is', Rounded_BMI)

if BMI >= 40:
  print('Your BMI classification is Morbidly Obese.\nYour health risks are extremely high')
elif BMI >= 35:
  print('Your BMI classification is Severely Obese.\nYour health risks are very high')
elif BMI >= 30:
  print('Your BMI classification is Obese.\nYour health risks are high')
elif BMI >= 25:
  print('Your BMI classification is Overweight.\nYou have increased health risks')
elif BMI >= 18.5:
  print('Your BMI classification is Normal Weight.\nYour health risks are minimal')
elif BMI >= 0:
  print('Your BMI classification is Underweight.\nYour health risks are minimal')
else:
  print('Invalid')
