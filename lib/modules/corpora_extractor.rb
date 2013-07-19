#For each language tag, it queries DBPEdia RDF labels and save these labels on files.
#It outputs the coverage per language tag in the end of the process.
#Usage:
#a = DbpediaLangTagVerification::Corpora.new()  
#a.all_languages("http://dbpedia.org/ontology/Book" ,['en', 'fr', 'de', 'es', 'pt', 'ru'])
# a.all_languages("http://dbpedia.org/ontology/Film" ,['en', 'fr', 'de', 'es', 'pt', 'ru'])
  
#@author Samur Araujo
module DbpediaLangTagVerification
  class Corpora
    @endpoint=nil
    def initialize (target=:lod)
      puts "MOUNTING ENDPOINT CONNECTION"
      if target == :lod
        @endpoint = mount_adapter("http://lod.openlinksw.com/sparql?default-graph-uri=http://dbpedia.org")
      else
        @endpoint = mount_adapter("http://dbpedia.org/sparql?default-graph-uri=http://dbpedia.org")
      end    
    end
 

    def all_languages(_class, tags)
      total = Query.new.adapters(@endpoint).sparql("SELECT distinct count(distinct ?s) WHERE {?s ?p <#{_class}> . ?s <http://www.w3.org/2000/01/rdf-schema#label> ?o . }").execute.flatten.first.to_i
      tags = Query.new.adapters(@endpoint).sparql("SELECT distinct lang(?o)    WHERE {?s ?p  <#{_class}> . ?s <http://www.w3.org/2000/01/rdf-schema#label> ?o    }").execute.flatten.sort if tags == nil

      coverage = tags.map{|tag|  100 *  individual_language(_class, tag)   / total }
       
      puts "RESULTS FOR #{_class}: Resources #{total}"
      puts "LANGUAGE TAGS: #{tags.join(" ")}"
      printf "COVERAGE LANGUAGE TAG: #{coverage.map { "%.0f%%" }.join(" ")}\n", *coverage
      

    end

    def individual_language(_class, tag)       
      results = Query.new.adapters(@endpoint).sparql("SELECT distinct ?o   WHERE {?s ?p <#{_class}> . ?s <http://www.w3.org/2000/01/rdf-schema#label> ?o .filter (lang(?o) = '#{tag}') }").execute
      f = File.open("../labels/queried/log_#{tag}_#{_class.split("/").last}", "w")
      results.each{|x|          
        f.write(x[0])
        f.write("\n")
      }
      f.flush
      f.close
      return  results.size.to_f
    end 
    def ground_truth_dbpedia(limit=300)
      Dir.foreach("../labels/") {|f|
        _limit=limit
        next if !f.index("log")
        tag = f.split("_")[1]
        y = File.open( "../labels/ground_truth/selected/" +f.to_s,"w")
        f = File.open( "../labels/" +f,"r")

        while (x = f.gets)
          x= x.gsub(/[()].+[()]/,"").rstrip.downcase
          next if !x.rstrip.index(/\s/)
          _limit -=1
          next if _limit < 0 
          y.write( x )
          y.write("\n" )
        end
        f.close
        y.close
      }

    end 

    def mount_adapter(endpoint, method=:post,cache=true)
      adapter=nil
      begin
        adapter = ConnectionPool.add_data_source :type => :sparql, :engine => :virtuoso, :title=> endpoint , :url =>  endpoint, :results => :sparql_xml, :caching => cache , :request_method => method
      rescue Exception => e
        puts e.getMessage()
        return nil
      end
      return adapter
    end
  end
end



#a = DbpediaLangTagVerification::Corpora.new()  
#a.all_languages("http://dbpedia.org/ontology/Book" ,['en', 'fr', 'de', 'es', 'pt', 'ru'])
# a.all_languages("http://dbpedia.org/ontology/Film" ,['en', 'fr', 'de', 'es', 'pt', 'ru'])
 
 
 

 