require 'set'
=begin 
Chapter 9: More Advanced Data Structures
----------------------------------------

What we will learn:
	How to build and use data structures that allow more complexity and usefulness than arrays
	and hashes. 

Sections:
9.1 Sets
9.2 Stacks and Queues
9.3 Trees
9.4 Graphs
9.5 Conclusion


Questions I have:
1. Is a set an unordered array? 
	yes and more
2. Where would you use a set in software?
3. Is a set purely a methematical concept?
	No, it is a high level concept that is modelled (attempted to be) in mathematics.
4. Why do sets exist? 
	Because they provide an ID structure to unordered data, as well as a
	relational structure through subsets, supersets, power sets, and proper subsets.
----------------------------------------

9.1 Working with sets
---------------------

---------------------------------------------------------------------------------------------
(adapted from the intuitive set theory wikipedia)
What is a mathematical set?
	 Simply it is an unordered grouping of individual objects into one object, a basic example
	being the venn diagram. The (elements or members) of a set can be anything, but they must 
	be distinct objects already, with no need for further definition. 
	 A set can only be equal to another set if tehy contain precisely the same elements (again,
	sets are unordered).

How is a set described?
	 In ruby, sets will be described by extension ( {} ). The objects are grouped by curly 
	brackets and separated by commas, and assigned to variables.
	 Sets can be defined intentionally ( {} ) or extensionally (a_set = b_set). When defined 
	extensionally, a set containing the same objects, but in differing quantities, are considered
	the same, as multiple identical objects are not relevant to the set, just as the order is not
	relevant to the set.
=end
		#Example (first rule of extensionality)
			a = Set[2,3,4]
			b = Set[2,2,3,4,4]
			p 't' if a == b
			p a # => {2, 3, 4}
			p b # => {2, 3, 4}

		#Example (second rule of extensionality)
			c = Set[3,4,2]
			p 't' if a == c
			p c # => {3, 4, 2}
			p c.class

=begin
(back to The Ruby Way)
To use set, we must (require 'set'). This also adds :to_set to the Enumerable module.
	(??????????not sure about to_set??????????????)

 We can create a new set with :new, [], or :new with a ':map-like' preprocessing block.
=end
	#Examples of set creation
		a = Set[3,6,4,1]
		array = [3,5,2,1]
		b = Set.new(array)
		c = Set.new(array) {|i| i.to_f*2}

=begin
9.1.1 Simple Set Operations
---------------------------
Union: sets can be added together with :union(set to be added), |, or +. When using :union()
	   you must assign the result to a new variable, as there is no in place modification.

	Examples
=end
		c = a.union(b) # => {3,6,4,1,5,2}
		d = a | b 	   # => {3,6,4,1,5,2}
		e = a + b 	   # => {3,6,4,1,5,2}

=begin
Intersection: An intersection is a construct built with elements shared by two sets. 
			  This can be accomplished similarly to :union(), with :intersection() or &.

	Examples
=end
		a = Set[2,4,5,6]
		b = Set[2,5,6,8,4,2,5,6]
		c = a.intersection(b) # => {2, 5, 6, 4}
		d = a & b 			  # => {2, 5, 6, 4}

#Membership is tested with :member? or :include?

	#Examples

		a.include?(5)    # => true
		a.include?('x')  # => false
		a.member?(2)	 # => true
		Set[2,5,'x',:whatever].include?('Jim') # => false


#Testing for null or empty sets with :empty?, and can clear a set with :clear

	#Examples

		p a.include?(2) # => true
		p a.empty? 		# => false
		p a.clear  		# => #<Set: {}> (returns an empty set)
		p a.include?(2) # => false
		p a.empty? 		# => true

=begin
Testing for Subsets, supersets, and proper_subsets: We test if a method receiver is a subset or 
superset of another set using :subset?() and :superset?(). We test if the receiver is a proper
subset using :proper_subset?

Definitions:
	Subset: Every memeber of set A is a memeber of set B
	Superset: B includes or contains every member of A
	Proper Subset: A is a subset of, but not equal to B
	Proper Superset: B is a superset of, but not equal to A

This is the language we use to define the relationships between sets.
=end
	#Examples
	p "Relational Examples"
		us_usernames = Set['Jamesxxbo', 'lucy9', 'Jimbo55', 'Alvin']
		ger_usernames = Set['HansGreuber', 'Hansel', 'ColKlompf', 'bmwenthusiast', 'Alvin']
		all_usernames = us_usernames | ger_usernames

		p all_usernames.subset?(us_usernames) 		 # => false
		p us_usernames.subset?(all_usernames) 		 # => true
		p us_usernames.proper_subset?(all_usernames) # => true
		p all_usernames.subset?(all_usernames) 		 # => true
		p all_usernames.proper_subset?(all_usernames)# => false
		p us_usernames.superset?(ger_usernames) 	 # => false
		p all_usernames.superset?(ger_usernames) 	 # => true


# :add and :add? 
	#These methods add items to an array, with :add? returning nil if the item already exists.
	#<< and :add are identical

	#Examples
	p ":add and :add? examples"
		#p us_usernames.add('bleepbloop', 'Precious Dream') # => ArgumentError wrong # arguments
		p us_usernames.add('bleepbloop') # => #<Set: {"Jamesxxbo", "lucy9", "Jimbo55", "Alvin", "bleepbloop"}>
		p ger_usernames << 'ilikekloks' # => #<Set: {"HansGreuber", "Hansel", "ColKlompf", "bmwenthusiast", "Alvin", "ilikekloks"}>
		p ger_usernames << 'ilikekloks' # => same as above
		p ger_usernames.add?('ilikekloks') # => nil
	
	#We can see between add and add? that adding multiple of the same values to a set does not
	#affect the set, but we can control the feedback by letting it happen or returning nil.

# :merge
	#Merges the elements of a given enumerable object into the set and returns itself

	#Examples
	p ":merge examples"
		jp_usernames = ['totorofan86', 'wwwwwwww', 'gomashio']
		p all_usernames.merge(jp_usernames)

		eur_usernames = Set['rubbishbin', 'mrholmes999']
		p all_usernames.merge(eur_usernames) #this would be better accomplished with +

	#we see here that a set is indeed an enumerable. 

# :replace 
	#replace replaces the receiving set with the contents of an enumerable.
	p ":replace examples"
		p us_usernames.replace(jp_usernames)
		p us_usernames.class # => set

# Equivalency 
	p "Equivalency examples"
		p us_usernames == jp_usernames # => false (since one is a set, and one is an array after the merge)
		p us_usernames == ger_usernames # => false
		p us_usernames != all_usernames # => true

=begin 
9.1.2 More Advanced Set Operations

We CAN iterate over a set, but due to its unordered nature, this is not reliable. 
To accomplish sortin through enumeration, we use :classify, which is similar to :group_by
in that it 
	A. returns a hash 
	B. that has keys determined by the return of the block passed to partition
	C. and assigns values to the keys as sets related to those key evaluations.
=end
	p ":classify examples"
	username_len_hash = all_usernames.classify do |user|
		if user.length <= 5
			:short
		elsif user.length > 5 && user.length <= 10
			:medium
		else 
			:long
		end
	end
	p long_len_usernames = username_len_hash[:long]
	p avg_len_usernames = username_len_hash[:medium]
	p "////////////////////////////////"
=begin
:divide will divide a set into subsets accourding to a 'commonality' defined in the block. This means that when any group of members share in common a trait (???????????is equivalency the only trait to find commonality????????????????????), they will go in a subset with their common members. 

The only examples I found in documentation were of grouping sets of numbers by their distance from each other, which seems limited in application, but I guess we could use this to group/filter strings by regex or something.

:divide enumerates over sets and returns sets inside a set that needs to be assigned to a new variable.

If one argument is passed into the block, :divide will put everything that matches the condition in one set  and everything else in another. If it has two arguments to evaluate in the block, it will call two objects into the block. 

I could see the one argument variant used to quickly filter and split off portions of the set to move to other sets.
=end
	p ":divide examples"
		user_names_a = all_usernames.divide {|user| user[0].downcase == 'a'}
		p user_names_a
	#something like this could work with custom input for the letter to filter for, then return the matching set to the webpage.

=begin
9.2 Working with Stacks and Queues
------------------------------------------------
A stack is a group of items that are stacked on top of each other, coming in the same end they are going out. 
A queue is a group of items that are 'waiting in line' going in one end and coming out another. 
Because these concepts are high level, they do not exist in the standard library, rather we will define our own classes to add these structures to our program. 

The stack class defined here is to prevent regular unrestricted array access and make sure that the data we want to treat as a stack is treated as a stack. 
=end
		class Stack

			def initialize
				@store = [] #creates an instance variable to navigate the stack through Stack's methods.
			end

			def push(x)
				@store.push x #add values to the end
			end

			def pop
				@store.pop #removes values from the end
			end

			def peek
				@store.last #lets us see the item on top
			end

			def empty?
				@store.empty? #allows us to check whether our stack is empty(finished)
			end
		end


		def paren_match(str)
			stack = Stack.new
			lsym = "{[(<"
			rsym = "}])>"
			str.each_char do |sym|
				if lsym.include? sym
					stack.push(sym)                  #Here we are adding the opening parentheses to stack
				elsif rsym.include? sym
					top = stack.peek
					if lsym.index(top) != rsym.index(sym)   #Here we see if the closing matches the opening
						return false
					else
						stack.pop                       #Remove it if it matches
					end
				end
			end
			return stack.empty?                         #if the stack clears, everything opened and closed
		end

		str1 = "(((a+b))*((c-d)-(e*f))"
		str2 = "[[(a-(b-c))],[[x,y]]]"

		p "paren_match stack example"
		p paren_match str1
		p paren_match str2

=begin
2.4 Implementing a stricter queue
-----------------------------------

In the same way that we built a Stack class to prevent us from illegally accessing our collection we wanted to use as a stack, the book will show us how to do the same thing with a Queue class. 
	My guesses for differences will be primarily entry and exit, and there will be less emphasis on :empty? even though it will exist. 
=end
	class Queue

		def initialize
			@store = []
		end

		def enqueue(x)
			@store<<x
		end

		def dequeue
			@store.shift
		end

		def peek
			@store.first
		end

		def length
			@store.length
		end

		def empty?
			@store.empty?
		end

	end

diff = Set[1,2,3,4] - Set[1,1,3]
p diff





p not_ger = all_usernames - ger_usernames

		






	