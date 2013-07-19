require "dbpedia_lang_tag_verification/version"
require "active_rdf/lib/active_rdf.rb"
require "activerdf_sparql-1.3.6/lib/activerdf_sparql/init.rb"


require "modules/corpora_extractor.rb"
require "modules/evaluation.rb" 

#Corpora Extraction 
#a = DbpediaLangTagVerification::Corpora.new()  
#a.all_languages("http://dbpedia.org/ontology/Book" ,['en', 'fr', 'de', 'es', 'pt', 'ru'])
# a.all_languages("http://dbpedia.org/ontology/Film" ,['en', 'fr', 'de', 'es', 'pt', 'ru'])
 
 
#Evaluation 
# a = DbpediaLangTagVerification::Evaluation.new()
# a.accuracy_dbpedia()
# a.accuracy_tools("TextCat")
# a.accuracy_tools("CybozuLabs")