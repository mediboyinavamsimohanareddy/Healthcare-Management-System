const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const dns = require('dns');
require('dotenv').config();

// Apply the Windows Node v24 DNS resolution fix
dns.setServers(['8.8.8.8', '1.1.1.1']);

const Doctor = require('./models/Doctor');

const seedDoctors = async () => {
  try {
    console.log('Connecting to database...');
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Database connected successfully.');

    // Clear existing doctors
    console.log('Clearing old doctor records...');
    await Doctor.deleteMany();

    // Hash a common password for all seeded doctors
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('doctor123', salt);

    const doctorsData = [
      {
        name: 'Dr. Amit Sharma',
        email: 'amit.sharma@medicare.com',
        password: hashedPassword,
        specialty: 'Cardiologist',
        experience: '15 years',
        phone: '9876543210',
        bio: 'Specialist in cardiovascular diseases, angioplasty, and preventative heart care.',
        profileImage: '',
        rating: 4.9,
        reviewsCount: 124,
        price: 1000,
      },
      {
        name: 'Dr. Priya Patel',
        email: 'priya.patel@medicare.com',
        password: hashedPassword,
        specialty: 'Dermatologist',
        experience: '10 years',
        phone: '9876543211',
        bio: 'Expert in skin care, acne treatment, anti-aging therapies, and cosmetic dermatology.',
        profileImage: '',
        rating: 4.7,
        reviewsCount: 89,
        price: 600,
      },
      {
        name: 'Dr. Rajesh Verma',
        email: 'rajesh.verma@medicare.com',
        password: hashedPassword,
        specialty: 'Pediatrician',
        experience: '12 years',
        phone: '9876543212',
        bio: 'Dedicated to children’s health, growth monitoring, immunizations, and pediatric illnesses.',
        profileImage: '',
        rating: 4.8,
        reviewsCount: 156,
        price: 500,
      },
      {
        name: 'Dr. Sunita Rao',
        email: 'sunita.rao@medicare.com',
        password: hashedPassword,
        specialty: 'Gynecologist',
        experience: '18 years',
        phone: '9876543213',
        bio: 'Expert in maternal-fetal medicine, prenatal care, and general women’s reproductive health.',
        profileImage: '',
        rating: 4.9,
        reviewsCount: 202,
        price: 800,
      },
      {
        name: 'Dr. Vikram Malhotra',
        email: 'vikram.malhotra@medicare.com',
        password: hashedPassword,
        specialty: 'Orthopedic Surgeon',
        experience: '14 years',
        phone: '9876543214',
        bio: 'Specialized in joint replacement, sports injuries, and complex bone reconstructive surgeries.',
        profileImage: '',
        rating: 4.6,
        reviewsCount: 78,
        price: 900,
      },
      {
        name: 'Dr. Anjali Desai',
        email: 'anjali.desai@medicare.com',
        password: hashedPassword,
        specialty: 'Neurologist',
        experience: '9 years',
        phone: '9876543215',
        bio: 'Diagnosis and management of neurological disorders, epilepsy, migraine, and stroke.',
        profileImage: '',
        rating: 4.8,
        reviewsCount: 65,
        price: 1100,
      },
      {
        name: 'Dr. Sandeep Nair',
        email: 'sandeep.nair@medicare.com',
        password: hashedPassword,
        specialty: 'Ophthalmologist',
        experience: '11 years',
        phone: '9876543216',
        bio: 'Eye surgeon specializing in cataracts, laser vision correction, and glaucoma management.',
        profileImage: '',
        rating: 4.7,
        reviewsCount: 92,
        price: 700,
      },
      {
        name: 'Dr. Shalini Gupta',
        email: 'shalini.gupta@medicare.com',
        password: hashedPassword,
        specialty: 'Psychiatrist',
        experience: '8 years',
        phone: '9876543217',
        bio: 'Compassionate therapist for clinical depression, anxiety disorders, and stress management.',
        profileImage: '',
        rating: 4.5,
        reviewsCount: 48,
        price: 800,
      },
      {
        name: 'Dr. Rohan Mehra',
        email: 'rohan.mehra@medicare.com',
        password: hashedPassword,
        specialty: 'Dentist',
        experience: '7 years',
        phone: '9876543218',
        bio: 'Expert in root canal therapy, orthodontics, teeth whitening, and oral hygiene.',
        profileImage: '',
        rating: 4.6,
        reviewsCount: 74,
        price: 500,
      },
      {
        name: 'Dr. Neha Kulkarni',
        email: 'neha.kulkarni@medicare.com',
        password: hashedPassword,
        specialty: 'General Physician',
        experience: '16 years',
        phone: '9876543219',
        bio: 'Comprehensive family medicine, treating chronic ailments, fevers, and regular checkups.',
        profileImage: '',
        rating: 4.8,
        reviewsCount: 215,
        price: 400,
      },
      {
        name: 'Dr. Kunal Sen',
        email: 'kunal.sen@medicare.com',
        password: hashedPassword,
        specialty: 'Endocrinologist',
        experience: '13 years',
        phone: '9876543220',
        bio: 'Specialist in diabetes care, thyroid disorders, and metabolic hormonal management.',
        profileImage: '',
        rating: 4.7,
        reviewsCount: 57,
        price: 900,
      },
      {
        name: 'Dr. Harish Joshi',
        email: 'harish.joshi@medicare.com',
        password: hashedPassword,
        specialty: 'ENT Specialist',
        experience: '10 years',
        phone: '9876543221',
        bio: 'Treating disorders of the ear, nose, throat, sinusitis, and sleep apnea.',
        profileImage: '',
        rating: 4.6,
        reviewsCount: 83,
        price: 600,
      },
      {
        name: 'Dr. Meera Krishnan',
        email: 'meera.krishnan@medicare.com',
        password: hashedPassword,
        specialty: 'Oncologist',
        experience: '15 years',
        phone: '9876543222',
        bio: 'Specialized in chemotherapy, early cancer detection, and advanced oncology care.',
        profileImage: '',
        rating: 4.9,
        reviewsCount: 110,
        price: 1200,
      },
      {
        name: 'Dr. Devendra Gowda',
        email: 'devendra.gowda@medicare.com',
        password: hashedPassword,
        specialty: 'Urologist',
        experience: '12 years',
        phone: '9876543223',
        bio: 'Expert in kidney stones, prostate treatment, and male/female urinary tract health.',
        profileImage: '',
        rating: 4.5,
        reviewsCount: 39,
        price: 800,
      },
      {
        name: 'Dr. Aditi Singh',
        email: 'aditi.singh@medicare.com',
        password: hashedPassword,
        specialty: 'Gastroenterologist',
        experience: '11 years',
        phone: '9876543224',
        bio: 'Specialist in liver disease, acidity, irritable bowel syndrome (IBS), and endoscopy.',
        profileImage: '',
        rating: 4.8,
        reviewsCount: 71,
        price: 750,
      },
    ];

    console.log('Inserting 15 doctor records with ratings, reviews, and pricing...');
    await Doctor.insertMany(doctorsData);
    console.log('Successfully seeded 15 doctors into the database!');

    mongoose.disconnect();
    console.log('Disconnected from database.');
  } catch (error) {
    console.error('Error seeding doctors:', error.message);
    process.exit(1);
  }
};

seedDoctors();
