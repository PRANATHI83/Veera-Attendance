// Create or update attendance table
async function initializeDatabase() {
    try {
        // Create attendance table if it doesn't exist
        await pool.query(`
            CREATE TABLE IF NOT EXISTS attendance (
                id SERIAL PRIMARY KEY,
                employee_id VARCHAR(7) NOT NULL CHECK (employee_id ~ '^ATS0[0-9]{3}$'),
                date DATE NOT NULL,
                clock_in TIME,
                clock_out TIME,
                duration VARCHAR(20),
                status VARCHAR(20),
                created_at TIMESTAMP DEFAULT NOW(),
                updated_at TIMESTAMP DEFAULT NOW(),
                UNIQUE(employee_id, date)
            );
        `);

        // Check if updated_at column exists, and add it if missing
        const columnCheck = await pool.query(`
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_name = 'attendance' AND column_name = 'updated_at';
        `);

        if (columnCheck.rows.length === 0) {
            await pool.query(`
                ALTER TABLE attendance 
                ADD COLUMN updated_at TIMESTAMP DEFAULT NOW();
            `);
            console.log('Added updated_at column to attendance table');
        }

        console.log('Attendance table initialized');
    } catch (error) {
        console.error('Error initializing database:', error);
    }
}

initializeDatabase();