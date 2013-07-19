LanguageIdentification
======================

Describe results on language identification on DBPedia RDF Labels

The ground truth is located in the directory labels/ground_truth_/tagged. Each file contain 300 entity labels extract from DBPedia and manually annotated.

The results in the directory results. In this directory the files dbpedia.txt, TextCat.txt and CybozuLabs.txt contains the accuracy of dbpedia existing tag compared to the ground truth and the accuracy of TextCat and CybozuLabs, respectively.

To reuse the code for different classes, edit the code below in the file ./lib/dbpedia_langtag_verification.rb:

	a = DbpediaLangTagVerification::Corpora.new()  
	a.all_languages("http://dbpedia.org/ontology/Book" ,['en', 'fr', 'de', 'es', 'pt', 'ru'])

Notice that you have to mannualy tag your new ground truth.

Then you can compute the accuracy with:

	a = DbpediaLangTagVerification::Evaluation.new()
	a.accuracy_dbpedia()
	a.accuracy_tools("TextCat")
	a.accuracy_tools("CybozuLabs")	 
	
Edit the the file ./lib/dbpedia_langtag_verification.rb, and then run:

	ruby ./lib/dbpedia_langtag_verification.rb


Fell free to use and distribute the code and ground truth.

@Samur Araujo
NO LICENSE REQUIRED (NLR)



