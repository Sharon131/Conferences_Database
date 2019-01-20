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
    print("Test fakera. Fałszywa godzina : " + fake.time("%H:%M:%S", None))
    fake_time = fake.time_object(end_datetime=None)
    print("Test fakera. Fałszywy czas 2 sposób: " + fake_time.strftime("%H:%M:%S"))
    past_date1 = fake.past_datetime("-3y", None)
    past_date2 = fake.past_datetime("-3y", None)
    print("Test faker. Is date1 before date2?: ", (past_date1 < past_date2))
    print("Date1: ", past_date1, "date2: ", past_date2)


def add_customers():
    # print("Customers")
    customers_no = random.randint(70, 90)

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
    # print("Conferences")
    conferences_no = random.randint(60, 80)

    for h in range(0, conferences_no):
        conference = create_conference()
        cursor.execute("INSERT INTO Conferences(TookPlace, Description) values(?,?);", conference)


def create_conference():
    took_place = get_weighted_probability(1, 3)
    conference = (took_place, fake.text())
    return conference


def get_weighted_probability(frequency_of_zero, frequency_of_one):
    interval = (frequency_of_zero + frequency_of_one)*10
    random_number = random.randint(0, interval)

    if random_number < frequency_of_zero*10:
        return 0
    else:
        return 1


def add_pricing_levels():
    # print('Pricing Levels')
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
    # print('Conferences Days')
    cursor.execute("SELECT ConferenceID, TookPlace FROM Conferences;")
    conferences = cursor.fetchall()

    for conference in conferences:
        start_date = get_random_date(conference.TookPlace)
        enrollment_start_day = get_random_date(conference.TookPlace)
        while start_date < enrollment_start_day:
            enrollment_start_day = get_random_date(conference.TookPlace)
        duration_in_days = random.randint(2, 3)
        for day_no in range(0, duration_in_days):
            date_of_day = start_date + datetime.timedelta(days=day_no)
            seats_no = random.randint(100, 300)
            price = random.randint(50, 100)
            cursor.execute("SELECT PricingLevelID from PricingLevels;")
            pricing_level = cursor.fetchone()
            enrollment_day = enrollment_start_day + datetime.timedelta(days=day_no)
            conference_day = (conference.ConferenceID, date_of_day.strftime('%m-%d-%Y'), seats_no, price,
                              pricing_level[0], enrollment_day.strftime('%m-%d-%Y'))
            cursor.execute("INSERT INTO ConferencesDays(ConferenceID, DayDate, SeatNo,BasicPrice, PricingLevelID, EnrollmentStartDay) values(?,?,?,?,?,?);",
                          conference_day)


def add_workshops():
    # print('Workshops')

    cursor.execute("SELECT ConferenceDayID, SeatNo FROM ConferencesDays;")
    conferences_days = cursor.fetchall()

    for conference_day in conferences_days:
        workshops_no = random.randint(3, 5)
        conference_seats_left = conference_day.SeatNo

        for h in range(0, workshops_no):
            start_time = fake.time(pattern='%H:%M:%S', end_datetime=None)
            duration = fake.time(pattern='%H:%M:%S', end_datetime=None)

            seats_no = get_random_seat_no(conference_seats_left)
            conference_seats_left -= seats_no

            is_workshop_for_free = get_weighted_probability(3, 2)
            if is_workshop_for_free:
                price = 0
            else:
                price = random.randint(10, 50)

            is_cancelled = get_weighted_probability(4, 1)
            enrollment_day = get_random_date(1)
            workshop = (start_time, duration, seats_no,
                        conference_day.ConferenceDayID, price, is_cancelled, enrollment_day.strftime('%m-%d-%Y'))
            cursor.execute(
                "INSERT INTO Workshops(StartTime, Duration, SeatNo, ConferenceDayID, Price, IsCancelled, EnrollmentStartDay) values (?,?,?,?,?,?,?);",
                workshop)


def get_random_seat_no(upper_limit):
    if upper_limit <= 0:
        return 0
    elif upper_limit <= 10:
        return upper_limit
    else:
        seats_no = random.randint(10, 50)
        while seats_no >= upper_limit:
            seats_no = random.randint(10, 50)
        return seats_no


def add_orders():
    # print('Orders')
    orders_no = 100

    cursor.execute("SELECT MAX(CustomerID) from Customers")
    max_customer_id = cursor.fetchone()
    cursor.execute("SELECT MIN(CustomerID) from Customers")
    min_customer_id = cursor.fetchone()

    for h in range(0, orders_no):
        order_date = get_random_date(1)
        customer_id = random.randint(min_customer_id[0], max_customer_id[0])
        order = (order_date.strftime('%m-%d-%Y'), customer_id)
        cursor.execute("INSERT INTO Orders(OrderDate, CustomerID) values(?,?);", order)


def add_payments():
    # print('Payments')
    cursor.execute("SELECT OrderID FROM Orders ORDER BY OrderDate;")
    orders_ids = cursor.fetchall()

    for order_id in orders_ids:
        is_order_payed = get_weighted_probability(1, 4)

        if is_order_payed:
            payment_date = get_random_date(1)
            value = random.randint(10, 500)             # should check, how much should be paid
            payment = (payment_date.strftime('%m-%d-%Y'), value)
            cursor.execute("INSERT INTO Payments(PaymentDate, Value) values(?,?);", payment)

            cursor.execute("SELECT TOP 1 PaymentID from Payments ORDER BY PaymentID DESC;")
            payment_id = cursor.fetchone()

            cursor.execute("UPDATE Orders SET PaymentID = ? WHERE OrderID = ?;", (payment_id[0], order_id[0]))


def add_attendees():
    # print('Attendees')
    attendees_no = random.randint(600, 800)

    cursor.execute("SELECT MAX(CustomerID) from Customers")
    max_customer_id = cursor.fetchone()
    cursor.execute("SELECT MIN(CustomerID) from Customers")
    min_customer_id = cursor.fetchone()

    for h in range(0, attendees_no):
        customer_id = random.randint(min_customer_id[0], max_customer_id[0])

        cursor.execute("SELECT * FROM Customers WHERE CustomerID = ?;", customer_id)
        customer = cursor.fetchone()
        is_company = customer.IsCompany
        has_name = get_weighted_probability(1, 5)

        if is_company and has_name == 0:
            attendee = (None, None, customer_id)
        else:
            attendee = (fake.first_name(), fake.last_name(), customer_id)
        cursor.execute("INSERT INTO Attendees(FirstName, LastName, CustomerID) values(?,?,?);", attendee)


def add_students():
    # print('Students')

    cursor.execute("SELECT AttendeeID FROM Attendees")
    attendees = cursor.fetchall()

    for attendee in attendees:
        is_student = get_weighted_probability(4, 1)

        if is_student:
            card_no = random.randint(100000, 999999)
            student = (card_no, attendee[0])
            cursor.execute("INSERT INTO Students(CardNo, AttendeeID) values(?,?);", student)


def add_conferences_reservations():
    # print("Conferences Reservations")

    cursor.execute("SELECT MIN(ConferenceDayID) FROM ConferencesDays")
    min_conference_day_id = cursor.fetchone()
    cursor.execute("SELECT MAX(ConferenceDayID) FROM ConferencesDays")
    max_conference_day_id = cursor.fetchone()

    cursor.execute("SELECT OrderID FROM Orders")
    orders = cursor.fetchall()

    for order in orders:
        reservations_no = random.randint(1, 5)

        for h in range(0, reservations_no):
            conference_day_id = random.randint(min_conference_day_id[0], max_conference_day_id[0])
            conference_reservation = (order[0], conference_day_id)
            cursor.execute("INSERT INTO ConferencesReservations(OrderID, ConferenceDayID) values(?,?);",
                           conference_reservation)


def add_conferences_attendees():
    # print("Conferences Attendees")

    cursor.execute("SELECT MIN(AttendeeID) FROM Attendees")
    min_attendee_id = cursor.fetchone()
    cursor.execute("SELECT MAX(AttendeeID) FROM Attendees")
    max_attendee_id = cursor.fetchone()

    cursor.execute("SELECT ConferenceReservationID FROM ConferencesReservations")
    conferences_reservations = cursor.fetchall()

    for conference_reservation in conferences_reservations:
        attendees_in_reservation_no = random.randint(1, 10)

        for h in range(0, attendees_in_reservation_no):
            attendee_id = random.randint(min_attendee_id[0], max_attendee_id[0])
            conference_attendee = (attendee_id, conference_reservation[0])
            cursor.execute("INSERT INTO ConferencesAttendees(AttendeeID, ConferenceReservationID) values(?,?);",
                           conference_attendee)

    cursor.execute("SELECT MIN(ConferenceReservationID) FROM ConferencesReservations")
    min_conferences_reservations_id = cursor.fetchone()
    cursor.execute("SELECT MAX(ConferenceReservationID) FROM ConferencesReservations")
    max_conferences_reservations_id = cursor.fetchone()

    cursor.execute("SELECT AttendeeID FROM Attendees WHERE AttendeeID NOT IN(SELECT AttendeeID FROM ConferencesAttendees)")
    attendees_left = cursor.fetchall()

    for attendee in attendees_left:
        conference_reservation_id = random.randint(min_conferences_reservations_id[0], max_conferences_reservations_id[0])
        conference_attendee = (attendee[0], conference_reservation_id)
        cursor.execute("INSERT INTO ConferencesAttendees(AttendeeID, ConferenceReservationID) values(?,?);",
                       conference_attendee)


def add_workshops_reservations():
    # print("Workshops_Reservations")

    cursor.execute("SELECT MIN(WorkshopID) FROM Workshops")
    min_workshop_id = cursor.fetchone()
    cursor.execute("SELECT MAX(WorkshopID) FROM Workshops")
    max_workshop_id = cursor.fetchone()

    cursor.execute("SELECT OrderID FROM Orders")
    orders = cursor.fetchall()

    for order in orders:
        reservations_no = random.randint(1, 5)

        for h in range(0, reservations_no):
            workshop_id = random.randint(min_workshop_id[0], max_workshop_id[0])
            workshop_reservation = (order[0], workshop_id)
            cursor.execute("INSERT INTO WorkshopsReservations(OrderID, WorkshopID) values(?,?);",
                           workshop_reservation)


def add_workshops_attendees():
    # print("Workshops Attendees")

    cursor.execute("SELECT MIN(ConferenceAttendeeID) FROM ConferencesAttendees")
    min_conference_attendee_id = cursor.fetchone()
    cursor.execute("SELECT MAX(ConferenceAttendeeID) FROM ConferencesAttendees")
    max_conference_attendee_id = cursor.fetchone()

    cursor.execute("SELECT WorkshopReservationID FROM WorkshopsReservations;")
    workshops_reservations = cursor.fetchall()

    for workshop_reservation in workshops_reservations:
        attendees_in_reservation_no = random.randint(1, 10)

        for h in range(0, attendees_in_reservation_no):
            conference_attendee_id = random.randint(min_conference_attendee_id[0], max_conference_attendee_id[0])
            workshop_attendee = (workshop_reservation[0], conference_attendee_id)
            cursor.execute("INSERT INTO WorkshopsAttendees(WorkshopReservationID, ConferenceAttendeeID) values(?,?);",
                           workshop_attendee)


print('Hi! Mr Bean is ready to add new records to your database.')


add_customers()
con.commit()

add_conferences()
con.commit()

add_pricing_levels()
con.commit()

add_conferences_days()
con.commit()

add_workshops()
con.commit()

add_orders()
con.commit()

add_payments()
con.commit()

add_attendees()
con.commit()

add_students()
con.commit()

add_conferences_reservations()
con.commit()

add_conferences_attendees()
con.commit()

add_workshops_reservations()
con.commit()

add_workshops_attendees()
con.commit()


con.commit()
con.close()

# test_faker()

print('Mr Bean has finished. He will not add anything new.')
