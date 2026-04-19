DROP DATABASE IF EXISTS ResistanceBase;
CREATE DATABASE ResistanceBase;
USE ResistanceBase;

create table mut (
		tipo varchar(50) not null primary key,
		descr varchar(300) not null
		)Engine=InnoDB;

create table fam ( 
		fam_id int not null primary key,
		nome_f varchar(50) not null
                )Engine=InnoDB;

create table mec (
		mec_id char(4) not null primary key,
		azione varchar(100) not null
                )Engine=InnoDB;

create table gruppo (
		group_id char(3) not null primary key,
		nome_gr varchar(20) not null,
		descr varchar(100) not null,
		reaz_gr	varchar(50) not null
                )Engine=InnoDB;

create table funz (
		funz_id char(10) not null primary key,
		term varchar(50) not null,
		tipo_f enum('BP','CC', 'MF') not null
                )Engine=InnoDB;

create table pathway (
		path_id char(4) not null primary key,
		nome_p varchar(100) not null
                )Engine=InnoDB;

create table riv (
		cod int not null primary key auto_increment,
		issue int not null,
		vol int not null,
		anno year not null,
		rivista varchar(30) not null
		)Engine=InnoDB;

create table art (
		pmid int not null primary key,
		autore varchar(30) not null,
		riv int not null,
		issue int not null,
		pag varchar(10) not null,
		titolo varchar(200) not null,
		foreign key (riv) references riv (cod) on update cascade on delete no action
                )Engine=InnoDB;

create table classe (
		class_id varchar(15) not null primary key,
		mec char(4) not null,
		foreign key (mec) references mec (mec_id) on update cascade on delete no action
		)Engine=InnoDB;


create table atc (
		atc_id char(4) not null primary key,
		nome_atc varchar(50) not null,
		target varchar(50) not null,
		path char(4) not null,
		foreign key (path) references pathway (path_id) on update cascade on delete no action
		)Engine=InnoDB;


create table subclass (
		sub_id char(5) not null primary key,
		nome_scl varchar(100) not null,
		atc_cl char(4) not null,
		foreign key (atc_cl) references atc (atc_id) on update cascade on delete no action
		)Engine=InnoDB;

create table ec (
		ec_id varchar(15) not null primary key,
		nome_e varchar(100) not null,
		reazione varchar(150) not null,
		gruppo char(3) not null,
		foreign key (gruppo) references gruppo (group_id) on update cascade on delete no action
		)Engine=InnoDB;


create table bat ( 
		bat_id int not null primary key,
		nome_sp varchar(100) not null,
		fam int not null,
		foreign key (fam) references fam (fam_id) on update cascade on delete no action
                )Engine=InnoDB;

create table res (
		res_id varchar(10) not null primary key,
		classe varchar(15) not null,
		mut varchar(50) not null,
		foreign key (classe) references classe (class_id) on update cascade on delete no action,
		foreign key (mut) references mut (tipo) on update cascade on delete no action
                )Engine=InnoDB;

create table seq (
		seq_id varchar(20) not null primary key,
		nome_s varchar(10) not null,
		bp int not null,
		tipo enum('Cromosoma','Plasmide') not null,
		compl enum('Y','N') not null,
		bat int not null,
		foreign key (bat) references bat (bat_id) on update cascade on delete no action
		)Engine=InnoDB;

create table prot (
		prot_id varchar(15) not null primary key,
		nome_pr varchar(10) not null,
		residui int not null,
		mw int not null,
		seq varchar(20) not null,	
		foreign key (seq) references seq (seq_id) on update cascade on delete no action
		)Engine=InnoDB;


create table ant (
		ant_id char(7) not null primary key,
		nome_a varchar(30) not null,
		formula varchar(20) not null,
		mw int not null,
		subcl char(5) not null,
                foreign key (subcl) references subclass (sub_id) on update cascade on delete no action
                )Engine=InnoDB;


create table resant (
		res varchar(10) not null,
		ant char(7) not null,		
		foreign key (res) references res (res_id) on update cascade on delete no action,
                foreign key (ant) references ant (ant_id) on update cascade on delete no action,
		primary key (res, ant)
                )Engine=InnoDB;

create table resart (
		res varchar(10) not null,
		art int not null,		
		foreign key (res) references res (res_id) on update cascade on delete no action,
                foreign key (art) references art (pmid) on update cascade on delete no action,
		primary key (res, art)
                )Engine=InnoDB;

create table resseq (
		res varchar(10) not null,
		seq varchar(20) not null,		
		foreign key (res) references res (res_id) on update cascade on delete no action,
                foreign key (seq) references seq (seq_id) on update cascade on delete no action,
		primary key (res, seq)
                )Engine=InnoDB;

create table req (
		res varchar(10) not null,
		req varchar(10) not null,		
		foreign key (res) references res (res_id) on update cascade on delete no action,
                foreign key (req) references res (res_id) on update cascade on delete no action,
		primary key (res, req)
                )Engine=InnoDB;

create table protfunz (
		prot varchar(15) not null,
		funz char(10) not null,
		foreign key (prot) references prot (prot_id) on update cascade on delete no action,
                foreign key (funz) references funz (funz_id) on update cascade on delete no action,
		primary key (prot, funz)
		)Engine=InnoDB;

create table enzima (
		prot varchar(15) not null,
		ec varchar(15) not null,
		primary key (prot, ec)
		)Engine=InnoDB;