matty = CongressMember.create(name: "Matty", state: "CA", party: "Birthday", title: "Sen")
will = CongressMember.create(name: "Will", party: "I", state: "CA", title: "Rep")

food = Issue.create(name: "Food")

big_money = Donation.create(amount: 500000, congress_member: matty, issue: food)
small_money = Donation.create(amount: 10, congress_member: will, issue: food)

more_cheese = Bill.create(name: "More Cheese", description: "Motion to increase cheese production and consumption", issue: food)

v1 = Vote.create(congress_member: matty, bill: more_cheese, vote: true)
v2 = Vote.create(congress_member: will, bill: more_cheese, vote: false)
