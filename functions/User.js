export class User{
    constructor(age, gender, maxAgePreference, minAgePreference, genderPreference) {
        this.age = age;
        this.gender = gender;
        this.maxAgePreference = maxAgePreference;
        this.minAgePreference = minAgePreference;
        this.genderPreferences = genderPreference;
    }

    determineGenderPreference() {
        switch(this.gender){
            case 'male': return 'malePreference';
            case 'female': return 'femalePreference';
            case 'other': return 'otherGenderPreference';
        }
    }
}