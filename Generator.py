import pyodbc
import random
from faker import Faker
import datetime

fake = Faker('pl_PL')

con = pyodbc.connect(r'Driver={SQL Server};Server=.\SQLEXPRESS;Database=ConferencesDB;Trusted_Connection=yes;')
cursor = con.cursor()


def test_faker():
    print("Test fakera. Fałszywe nazwisko: " + fake.name())
    print("Test fakera. Fałszywe imię: " + fake.first_name())
    print("Test fakera. Fałszywe nazwisko: " + fake.last_name())
    print("Przykładowy teskt: " + fake.text())
    print("Test fakera. Nazwa firmy: " + fake.company())
    date_example = fake.past_datetime("-3y", None)
    print("Test fakera. Fałszywa data: " + date_example.strftime('%d/%m/%Y'))
    future_date_in_date_format = fake.future_date("+30d", None)
    print("test fakera. Fałszywa przyszła data: " + future_date_in_date_format.strftime('%d/%m/%Y'))


def add_customers():
    customers_no = random.randint(60, 80)

    for h in range(0, customers_no):
        customer = create_customer()
        cursor.execute("INSERT INTO Customers(Name, Phone, IsCompany, NIP) values(?,?,?,?);", customer)


def create_customer():
    is_company = random.randint(0, 1)
    phone = fake.phone_number()

    if is_company == 1:
        nip = '0000000000'
        customer = (fake.company(), phone, is_company, nip)
    else:
        customer = (fake.name(), phone, is_company, None)
    return customer


def add_conferences():
    conferences_no = 60

    for h in range(0, conferences_no):
        conference = create_conference()
        cursor.execute("INSERT INTO Conferences(TookPlace, Description) values(?,?);", conference)


def create_conference():
    took_place = random.randint(0, 1)
    conference = (took_place, fake.text())
    return conference


def add_pricing_levels():
    print('Pricing Levels')
    pricing_level0 = (7, 0)
    cursor.execute("INSERT INTO PricingLevels(StartDay, Discount) values(?,?);", pricing_level0)
    pricing_level1 = (14, 0.10)
    cursor.execute("INSERT INTO PricingLevels(StartDay, Discount) values(?,?);", pricing_level1)
    pricing_level2 = (21, 0.20)
    cursor.execute("INSERT INTO PricingLevels(StartDay, Discount) values(?,?);", pricing_level2)
    pricing_level3 = (31, 0.30)
    cursor.execute("INSERT INTO PricingLevels(StartDay, Discount) values(?,?);", pricing_level3)


def get_random_date(is_from_past):
    if is_from_past == 0:
        return fake.future_datetime("+30d", None)
    else:
        return fake.past_datetime("-3y", None)


def add_conferences_days():
    print('Conferences Days')
    cursor.execute("SELECT ConferenceID, TookPlace FROM Conferences;")
    conferences = cursor.fetchall()

    for conference in conferences:
        print('Generating Conference Day')
        start_date = get_random_date(conference.TookPlace)
        enrollment_start_day = get_random_date(conference.TookPlace)
        duration_in_days = random.randint(2, 3)
        for day_no in range(0, duration_in_days):
            seats_no = random.randint(100, 300)
            date_of_day = start_date + datetime.timedelta(days=day_no)
            print(date_of_day.strftime('%d/%m/%Y'))
            # enrollment_day = enrollment_start_day + day
            # cursor.execute("INSERT INTO Conferences_Days(StartDay, Discount) values(?,?);", pricing_level3)


def add_orders():
    print('Orders')
    cursor.execute("SELECT ConferenceID FROM Conferences;")
    conferences = cursor.fetchall()

    for conference_id in conferences:
        print('Generating order for conference')

print('Hi! Beginning of the generator.')
# add_customers()
# add_conferences()
# add_pricing_levels()

add_conferences_days()

# add_orders()

cursor.execute("SELECT * FROM PricingLevels")

rows = cursor.fetchall()

for row in rows:
    print(row.PricingLevelID, row.StartDay, row.Discount)

cursor.execute("SELECT ConferenceID FROM Conferences")
rows = cursor.fetchall()

# for row in rows:
#    print(row[0])

con.commit()
con.close()

# test_faker()

print('Mr Bean has finished. He will not add anything new.')
