import { Surreal } from 'surrealdb.js';

const db = new Surreal();

async function main() {
	try {
		// Connect to the database
		await db.connect('http://127.0.0.1:8000/rpc', {
			// Set the namespace and database for the connection
			namespace: 'test',
			database: 'test',
			auth: {
				// Set the username and password for the connection
				username: 'root',
				password: 'root'
			}

		});

		// Create a new person with a random id
		const created = await db.create('person', {
			title: 'Founder & CEO',
			name: {
				first: 'Tobie',
				last: 'Morgan Hitchcock',
			},
			marketing: true,
			identifier: Math.random().toString(36).substr(2, 10),
		});
		console.log('created :>> ', created);

		// Update a person record with a specific id
		const updated = await db.merge('person:jaime', {
			marketing: true,
		});
		console.log('updated :>> ', updated);

		// Select all people records
		const people = await db.select('person');
		console.log('people :>> ', people);

		// Perform a custom advanced query
		const groups = await db.query(
			'SELECT marketing, count() FROM type::table($tb) GROUP BY marketing',
			{
				tb: 'person',
			}
		);
		console.log('groups :>> ', groups);
	} catch (e) {
		console.error(e);
	}
}

main();