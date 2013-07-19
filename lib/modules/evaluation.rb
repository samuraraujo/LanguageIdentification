 
module DbpediaLangTagVerification
  class Evaluation
    @endpoint=nil
    def initialize ( )

      _jars=''
      dir ="#{File.dirname(__FILE__)}/java/"
      Dir.foreach(dir) {|x|
        _jars += dir  + x +  File::PATH_SEPARATOR unless x.index('jar') == nil
      }
      begin
        vmargs = [ '-Xms256m', '-Xmx1024m' ]
        if RUBY_PLATFORM =~ /java/
          _jars = _jars.split(File::PATH_SEPARATOR)
          _jars.each{ |v| require v }
        else
          Rjb::load sesame_jars , vmargs
        end

      rescue => ex
        raise ex, "Could not load Java Virtual Machine. Please, check if your JAVA_HOME environment variable is pointing to a valid JDK (1.4+). #{ex}"

      rescue LoadError => ex
        raise ex, "Could not load RJB. Please, install it properly with the command 'gem install rjb'"
      end
      if RUBY_PLATFORM =~ /java/
        include_class 'com.cybozu.labs.langdetect.Detector'
        include_class 'com.cybozu.labs.langdetect.DetectorFactory'
        DetectorFactory.loadProfile(dir + "profiles");
        @bridge =   DetectorFactory.create();
      else
        Rjb::import('com.cybozu.labs.langdetect.DetectorFactory').loadProfile(dir + "profiles")
        @bridge = Rjb::import('com.cybozu.labs.langdetect.DetectorFactory').create()
      end
    end

    def cybozu(text)
      begin
        if RUBY_PLATFORM =~ /java/
          @bridge =   DetectorFactory.create();
        else
          @bridge = Rjb::import('com.cybozu.labs.langdetect.DetectorFactory').create()
        end
        @bridge.append(text)
        @bridge.detect()
      rescue Exception => e
        return "NN"
      end
    end

    def accuracy_dbpedia( )
       fout = File.open("../results/dbpedia.txt", 'w')
      Dir.foreach("../labels/ground_truth_/tagged/") {|fs|

        next if !fs.index("log")
        tag = fs.split("_")[1]

        f = File.open( "../labels/ground_truth_/tagged/" + fs, "r")
        correct = 0
        all=0
        while (x = f.gets)
          x=x.split("-")[0]
          correct +=1 if x == tag
          all+=1
        end
         r= correct.to_f / all.to_f
        fout.printf(fs + " %.2f"  , r)
        fout.write("\n")
        printf("#{fs} %.2f \n", r)
        puts "Results saved on ../results/dbpedia.txt"
        f.close

      }
      fout.close
    end

    def textcat(text)
      cmd = "/Users/samuraraujo/Downloads/text_cat/text_cat   -l \"#{text.rstrip}\" -t 3 -f | awk -F ' ' '{print $1}' "
      # puts cmd
      return  IO.popen(cmd).readlines.first
    end

    

    def accuracy_tools(app="CybozuLabs")
      xtag = ""
      correct = 0
      all=0
      fout = File.open("../results/#{app}.txt", 'w')
      Dir.foreach("../labels/ground_truth_/tagged") {|fs|
        next if !fs.index("log")
        correct = 0
        all=0
        f = File.open( "../labels/ground_truth_/tagged/" + fs, "r")
        puts fs
        while (x = f.gets)
          # puts x
          x=x.split("-")
          text = x[1..10].join("-")
          tag = x[0]

          if app == "CybozuLabs"
            x = cybozu(text)
          else
            x = textcat(text).rstrip
          end
          # puts x
          # puts tag
          correct +=1 if x == tag
          all+=1
        # puts all
        end

        r= correct.to_f / all.to_f
        fout.printf(fs + " %.2f"  , r)
        fout.write("\n")
        f.close

      }
      fout.close

    end

  end

end


