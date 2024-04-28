package main

import (
	"fmt"
	"log"
	"os"

	"github.com/go-faker/faker/v4"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	dsn string
)

type FakeSaasInfo struct {
	// shouldn't need ID here...
	EmployeeNumber uint8 `faker:"boundary_start=100, boundary_end=1000"`
	Founder        string  `faker:"name"`
	Funding        uint32 `faker:"boundary_start=1000000, boundary_end=100000000"`
	// monthly active users
	MAU     uint `faker:"boundary_start=10000, boundary_end=10000000"`
	Name    string `faker:"domain_name"`
	Type    string `faker:"oneof: AI, Crypto, B2B, B2B2B, B2Bro, DevSecAiOps, O11y, Finance, Disrupting AI"`
	Revenue float32 `faker:"boundary_start=10000.00, boundary_end=20000000.00"`
}

// GORM is ridic
type Tabler interface {
	TableName() string
}

// if we don't do this, GORM adds an "s" to the table name
func (FakeSaasInfo) TableName() string {
	return "sassy_sassinfo"
}

func main() {

	host := os.Getenv("DB_HOST")
	db_user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")

	dsn = fmt.Sprintf("host=%s user=%s password=%s dbname=postgres port=5432 sslmode=disable", host, db_user, password)

	database, err := gorm.Open(postgres.Open(dsn))
	if err != nil {
		fmt.Println("the problem is: ", err)
		panic("failed to connect to database")
	}

	numberOfRecords := 300
	for i := 0; i < numberOfRecords; i++ {
		var saasBiz FakeSaasInfo

		err := faker.FakeData(&saasBiz)
		if err != nil {
			log.Fatal(err)
		}

        id := database.Create(&saasBiz)
		fmt.Printf("inserted: %v", id)
	}

	// for the initcontainer logs
	fmt.Println("finished inserting database data")
}
