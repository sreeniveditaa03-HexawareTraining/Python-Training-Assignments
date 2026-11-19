// ============================================================
// SET 2: AIRLINE SEAT BOOKING
// ============================================================

// Tasks 1 and 5: Update seat status and insert booking atomically.
function bookSeat(flight, seat, passenger, fare) {

    transact("Seat booking", sd => {

        if(sd.airlineSeats.updateOne(
            {
                flightId:flight,
                seatNo:seat,
                status:"AVAILABLE"
            },
            {$set:{status:"BOOKED"}}
        ).modifiedCount !== 1)
            throw new Error("Seat unavailable");

        sd.airlineBookings.insertOne({
            flightId:flight,
            seatNo:seat,
            passengerName:passenger,
            fare:fare,
            bookedAt:new Date()
        });
    });
}

bookSeat(501,"1A","Nivedita",1200);

// Task 2: Test race by invoking booking for same seat from two mongosh sessions.
// One session succeeds; the other fails due to conditional status/write conflict.

print("Seats:");

d.airlineSeats.find({
    flightId:501
}).forEach(print);

print("Bookings:");

d.airlineBookings.find({
    flightId:501
}).forEach(print);

// Tasks 3 and 4: Ranking + revenue running total window aggregation.
d.airlineBookings.aggregate([
    {
        $setWindowFields:{
            partitionBy:"$flightId",
            sortBy:{fare:-1},
            output:{
                fareRank:{$rank:{}},
                denseFareRank:{$denseRank:{}}
            }
        }
    },
    {
        $setWindowFields:{
            partitionBy:"$flightId",
            sortBy:{bookedAt:1,_id:1},
            output:{
                runningRevenue:{
                    $sum:"$fare",
                    window:{
                        documents:["unbounded","current"]
                    }
                }
            }
        }
    },
    {$sort:{flightId:1,fareRank:1}}
]).forEach(print);

// RANK skips numbers after ties (1,1,3).
// DENSE_RANK does not skip numbers after ties (1,1,2).
