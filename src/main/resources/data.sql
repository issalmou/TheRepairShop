-- Reset demo data so startup remains idempotent
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE repair_images;
TRUNCATE TABLE repair_progress;
TRUNCATE TABLE repairs;
TRUNCATE TABLE devices;
TRUNCATE TABLE clients;
TRUNCATE TABLE shops;
TRUNCATE TABLE user_roles;
TRUNCATE TABLE roles;
TRUNCATE TABLE users;

-- Seed Roles
INSERT INTO roles (id, name) VALUES
(1, 'ADMIN'),
(2, 'OWNER'),
(3, 'REPARATEUR');

-- Shared BCrypt password for all users: password123
INSERT INTO users (id, user_type, username, email, password, first_name, last_name, phone, created_at, active, shop_id, company_name, tax_id, specialization, experience_years, hourly_rate, department, admin_level) VALUES
(1, 'REPARATEUR', 'amina.elidrissi', 'amina@repairshop.ma', '$2a$10$sSQNCEY5fLHsl.GORM8KAeAUd/.5ppS1vMznMfB/vwXDUetVvBfOa', 'Amina', 'El Idrissi', '0611223344', '2026-05-01 08:30:00', TRUE, 1, NULL, NULL, 'Smartphones', 3, '150 MAD', NULL, NULL),
(2, 'REPARATEUR', 'youssef.bennani', 'youssef@repairshop.ma', '$2a$10$sSQNCEY5fLHsl.GORM8KAeAUd/.5ppS1vMznMfB/vwXDUetVvBfOa', 'Youssef', 'Bennani', '0622334455', '2026-05-01 08:45:00', TRUE, 1, NULL, NULL, 'Laptops', 5, '200 MAD', NULL, NULL),
(3, 'OWNER', 'salma.alaoui', 'salma@repairshop.ma', '$2a$10$sSQNCEY5fLHsl.GORM8KAeAUd/.5ppS1vMznMfB/vwXDUetVvBfOa', 'Salma', 'Alaoui', '0633445566', '2026-05-01 09:00:00', TRUE, NULL, 'Alaoui Electro Group', 'TAX-MA-9988', NULL, NULL, NULL, NULL, NULL),
(4, 'ADMIN', 'admin', 'admin@repairshop.ma', '$2a$10$sSQNCEY5fLHsl.GORM8KAeAUd/.5ppS1vMznMfB/vwXDUetVvBfOa', 'System', 'Admin', '0600000000', '2026-05-01 07:00:00', TRUE, NULL, NULL, NULL, NULL, NULL, NULL, 'Operations', 'SUPER');

INSERT INTO user_roles (user_id, role_id) VALUES
(1, 3),
(2, 3),
(3, 2),
(4, 1);

INSERT INTO shops (id, owner_id, name, address, phone, active, created_at) VALUES
(1, 3, 'Atelier Hassan II', '77 Bd Hassan II, Casablanca', '0522001100', TRUE, '2026-05-01 09:30:00'),
(2, 3, 'Tech Souk Agdal', '14 Rue Oued Sebou, Rabat', '0537002200', TRUE, '2026-05-01 10:00:00'),
(3, 3, 'Marrakech Device Lab', '22 Av Mohammed VI, Marrakech', '0524303300', TRUE, '2026-05-01 10:30:00');

INSERT INTO clients (id, first_name, last_name, email, phone, address, shop_id, tracking_key, created_at) VALUES
(1, 'Karim', 'Ouazzani', 'karim.ouazzani@mail.ma', '0644556677', 'Hay Riad, Rabat', 1, 'TRK-MA-000001', '2026-05-02 11:00:00'),
(2, 'Nadia', 'Benjelloun', 'nadia.benjelloun@mail.ma', '0655667788', 'Maarif, Casablanca', 1, 'TRK-MA-000002', '2026-05-02 11:20:00'),
(3, 'Mehdi', 'Tazi', 'mehdi.tazi@mail.ma', '0666778899', 'Gueliz, Marrakech', 1, 'TRK-MA-000003', '2026-05-02 11:40:00'),
(4, 'Fatima', 'Zahra', 'fatima.zahra@mail.ma', '0677889900', 'Agdal, Rabat', 1, 'TRK-MA-000004', '2026-05-02 12:00:00'),
(5, 'Yassine', 'Mansouri', 'yassine.mansouri@mail.ma', '0688990011', 'Gueliz, Marrakech', 1, 'TRK-MA-000005', '2026-05-02 12:30:00'),
(6, 'Sanaa', 'Kabbaj', 'sanaa.kabbaj@mail.ma', '0699001122', 'Anfa, Casablanca', 1, 'TRK-MA-000006', '2026-05-02 13:00:00'),
(7, 'Othmane', 'Chraibi', 'othmane.chraibi@mail.ma', '0611223355', 'Hay Riad, Rabat', 1, 'TRK-MA-000007', '2026-05-02 13:30:00'),
(8, 'Laila', 'Amrani', 'laila.amrani@mail.ma', '0622334466', 'Maarif, Casablanca', 1, 'TRK-MA-000008', '2026-05-02 14:00:00'),
(9, 'Amine', 'Berrada', 'amine.berrada@mail.ma', '0633445577', 'Gueliz, Marrakech', 1, 'TRK-MA-000009', '2026-05-02 14:30:00'),
(10, 'Sofia', 'Tahiri', 'sofia.tahiri@mail.ma', '0644556688', 'Agdal, Rabat', 1, 'TRK-MA-000010', '2026-05-02 15:00:00'),
(11, 'Reda', 'Filali', 'reda.filali@mail.ma', '0655667799', 'Anfa, Casablanca', 1, 'TRK-MA-000011', '2026-05-02 15:30:00'),
(12, 'Meriem', 'Naji', 'meriem.naji@mail.ma', '0666778800', 'Hay Riad, Rabat', 1, 'TRK-MA-000012', '2026-05-02 16:00:00'),
(13, 'Hamza', 'Bennouna', 'hamza.bennouna@mail.ma', '0677889911', 'Maarif, Casablanca', 1, 'TRK-MA-000013', '2026-05-02 16:30:00'),
(14, 'Zineb', 'Guessous', 'zineb.guessous@mail.ma', '0688990022', 'Gueliz, Marrakech', 1, 'TRK-MA-000014', '2026-05-02 17:00:00'),
(15, 'Tarik', 'Jamil', 'tarik.jamil@mail.ma', '0699001133', 'Agdal, Rabat', 1, 'TRK-MA-000015', '2026-05-02 17:30:00'),
(16, 'Ghita', 'Fassi', 'ghita.fassi@mail.ma', '0611223366', 'Anfa, Casablanca', 1, 'TRK-MA-000016', '2026-05-02 18:00:00'),
(17, 'Anas', 'Slaoui', 'anas.slaoui@mail.ma', '0622334477', 'Hay Riad, Rabat', 1, 'TRK-MA-000017', '2026-05-02 18:30:00'),
(18, 'Yasmina', 'Kadiri', 'yasmina.kadiri@mail.ma', '0633445588', 'Maarif, Casablanca', 1, 'TRK-MA-000018', '2026-05-02 19:00:00');

INSERT INTO devices (id, client_id, brand, model, serial_number, device_type, notes, created_at) VALUES
(1, 1, 'Samsung', 'Galaxy S23', 'MA-SN-1001', 'Smartphone', 'Ecran fissure et batterie faible', '2026-05-03 09:00:00'),
(2, 2, 'Apple', 'MacBook Pro 14', 'MA-SN-1002', 'Laptop', 'Surchauffe et ventilateur bruyant', '2026-05-03 09:30:00'),
(3, 3, 'Lenovo', 'ThinkPad T14', 'MA-SN-1003', 'Laptop', 'Port USB-C endommage', '2026-05-03 10:00:00'),
(4, 4, 'Apple', 'iPhone 14 Pro', 'MA-SN-1004', 'Smartphone', 'Vitres arriere brisee', '2026-05-03 10:30:00'),
(5, 5, 'HP', 'Spectre x360', 'MA-SN-1005', 'Laptop', 'Pas de charge', '2026-05-03 11:00:00'),
(6, 6, 'Samsung', 'Galaxy Tab S9', 'MA-SN-1006', 'Tablet', 'Tactile ne repond plus', '2026-05-03 11:30:00'),
(7, 7, 'Sony', 'PlayStation 5', 'MA-SN-1007', 'Console', 'Surchauffe rapide', '2026-05-03 12:00:00'),
(8, 8, 'Apple', 'iPad Pro 12.9', 'MA-SN-1008', 'Tablet', 'Remplacement connecteur de charge', '2026-05-03 12:30:00'),
(9, 9, 'Asus', 'ROG Zephyrus', 'MA-SN-1009', 'Laptop', 'Changement ventilateur gauche', '2026-05-03 13:00:00'),
(10, 10, 'Google', 'Pixel 7 Pro', 'MA-SN-1010', 'Smartphone', 'Ecran noir', '2026-05-03 13:30:00');

INSERT INTO repairs (id, device_id, assigned_technician_id, created_by_id, status, description, diagnosis, final_cost, created_at, updated_at) VALUES
(1, 1, 2, 1, 'PENDING', 'Remplacement ecran et verification batterie', 'En attente de piece ecran', NULL, '2026-05-04 08:30:00', '2026-05-04 08:30:00'),
(2, 2, 2, 1, 'IN_PROGRESS', 'Nettoyage interne et changement pate thermique', 'Accumulation poussiere importante', NULL, '2026-05-04 09:10:00', '2026-05-05 14:20:00'),
(3, 3, 2, 1, 'COMPLETED', 'Reparation port USB-C', 'Port remplace avec succes', 650.00, '2026-05-04 09:50:00', '2026-05-06 16:10:00'),
(4, 4, 1, 1, 'PENDING', 'Remplacement vitre arriere', 'En attente de reception de la piece detachee', NULL, '2026-05-04 10:30:00', '2026-05-04 10:30:00'),
(5, 5, 2, 1, 'IN_PROGRESS', 'Diagnostic circuit de charge', 'Probleme potentiel de controleur IC', NULL, '2026-05-04 11:00:00', '2026-05-05 09:30:00'),
(6, 6, 1, 1, 'PENDING', 'Changement vitre tactile', 'Devis envoye au client', NULL, '2026-05-04 11:30:00', '2026-05-04 11:30:00'),
(7, 7, 2, 1, 'COMPLETED', 'Nettoyage poussiere et metal liquide', 'Refroidissement restaure a la normale', 450.00, '2026-05-04 12:00:00', '2026-05-06 11:00:00'),
(8, 8, 2, 1, 'IN_PROGRESS', 'Soudure port de charge USB-C', 'Verification des pistes de la carte mere', NULL, '2026-05-04 12:30:00', '2026-05-05 16:00:00');

INSERT INTO repair_progress (id, repair_id, status, note, created_at, created_by) VALUES
(1, 1, 'PENDING', 'Client informe du delai de la piece', '2026-05-04 10:00:00', 1),
(2, 2, 'IN_PROGRESS', 'Tests thermiques en cours', '2026-05-05 15:00:00', 2),
(3, 3, 'COMPLETED', 'Appareil teste et pret a etre rendu', '2026-05-06 16:15:00', 2),
(4, 4, 'PENDING', 'Commande passee chez le fournisseur officiel', '2026-05-04 11:00:00', 1),
(5, 5, 'IN_PROGRESS', 'Composants endommages detectes pres du port USB-C', '2026-05-05 10:00:00', 2),
(6, 7, 'COMPLETED', 'Console testee pendant 2 heures sous charge', '2026-05-06 11:30:00', 2);

INSERT INTO repair_images (id, repair_id, path, original_name, content_type, size, uploaded_at) VALUES
(1, 1, 'uploads/repairs/1/ecran-avant.jpg', 'ecran-avant.jpg', 'image/jpeg', 245678, '2026-05-04 10:05:00'),
(2, 2, 'uploads/repairs/2/ventilateur.jpg', 'ventilateur.jpg', 'image/jpeg', 198432, '2026-05-05 15:10:00'),
(3, 3, 'uploads/repairs/3/usb-c-apres.jpg', 'usb-c-apres.jpg', 'image/jpeg', 210987, '2026-05-06 16:20:00'),
(4, 4, 'uploads/repairs/4/vitre-dos.jpg', 'vitre-dos.jpg', 'image/jpeg', 120532, '2026-05-04 10:45:00'),
(5, 5, 'uploads/repairs/5/carte-mere.jpg', 'carte-mere.jpg', 'image/jpeg', 310452, '2026-05-05 10:15:00');

SET FOREIGN_KEY_CHECKS = 1;

