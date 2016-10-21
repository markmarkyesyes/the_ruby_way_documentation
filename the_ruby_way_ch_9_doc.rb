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
	No, it is a high level concept that is modelled (attempted to be represented) in mathematics.
4. Why do sets exist? 
	Because they provide an ID structure to unordered data, as well as a
	relational structure through subsets, supersets, power sets, and proper subsets.
	In the same ways that you create a stack or queue as an array by limiting its features
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

Stacks use a LIFO data structure, and must be defined in ruby to prevent a stack operation from accessing an array at a position other than the last item. When we want a stack, we want ONLY a stack, so we create the class to restrict access to the definitions of a stack. The primary operations we want to allow are a push, pop, and a peek (for conditional evaluation.)

9.2.1 Implementing a Stricter Stack
A simple implementation of these rules can be seen below.
=end
		class Stack

			def initialize
				@store = []
			end

			def push(x)
				@store.push x
			end

			def pop
				@store.pop
			end

			#These last two options allow for better conditional evaluation re stack operations

			def peek 
				@store.last
			end

			def empty?
				@store.empty?
			end

		end
=begin
See how we are usin array methods, but are using them syntactically in the way we would use a stack, and compartmentalizing them so we cannot use array methods that allow access to any position other than the last.

An example from SO given as to the application paradigms implicated by restricting arrays into these data structures are (for stacks) to do a 'depth first' walk, where we track our position on a tree by pushing a node onto the stack when we traverse to it, then popping it when we move back up the tree from it.

When using a queue for tree navigation, you will get a breadth first approach, which allows you to push the entire tree into a queue in order, then evaluate them from the highest to lowest branches of the tree.

These are very different methods of traversal, and at first glance, the differences in application seems to be in how much data you need to see and in what order you need to see it. As I type this and reflect, it would seem that fundamentally those needs will drive the formation of any custom data structure.

-----------------------------------------------------
9.2.2 Detecting Unbalanced Punctuation in Expressions
-----------------------------------------------------

We can use the traversal methods in a stack to navigate through an expression to make sure all open punctuations have been closed. This is an appropriate application because we need the openings first, then the closings, vs a queue which would require a counter system vs checking if the stack empties (that all openings have a closing). Data structures are all about making the right tool for the right job.
=end
	

	def paren_match(str)
		stack = Stack.new
		lsym = "{[(<"
		rsym = "}])>"
		str.each_char do |sym|
			if lsym.include? sym
				stack.push(sym)
			elsif rsym.include? sym
				top = stack.peek 	#Here we begin to check against the last opening expression which 						 should be the first closing expression.
				if lsym.index(top) != rsym.index(sym)
					return false 	#Here we check if an expression is out of order or missing
				else
					stack.pop
				end 				#This ignores non-grouped characters by leaving anything but 							characters pushed into the stack out of the conditional.
			end
		end

		return stack.empty? 		#This will check if there are extra closing parens/make sure the 
									# conditional evaluated properly.
	end

str1 =	"(((a+b))*((c-d)-(e*f))"
str2 =	"[[(a-(b-c))],	[[x,y]]]"

p paren_match str1 #false


p paren_match str2 #true

=begin
the 'nested nature' of this problem is what makes it a candidate for a stack oriented solution. Other similar applications would be html/xml tag openings and closures. You could even use it to match whitespace per line. This could be a good solution to noncongruent whitespace problems re people on the same team using different editors.

-----------------------------------------
9.2.3 Understanding Stacks and Recursion
-----------------------------------------

When solving problems that are more conditional and exponential in nature, a recursive stratey should be used for a problem which may seem applicable to a stack oriented solution. stacks are very binary, and therefore should not be used to solve exponential problems where a recursive solution will function in a more elegant manner.

----------------------------------------------------------------------
9.2.4 Implementing a Stricter Queue (And material from 9.2 on Queues)
----------------------------------------------------------------------

A queue is a Fifo system, meaning that whatever comes first is served first, and the rest of the data is piled up behind it. Whereas a stack is basically managing data with a preprocessor, a queue manages data with a postprocessor, and I would assume preprocessing the elements included.

A queue's application is also suited more to a realtime application (ie something where data cna enter at any time to 'wait' to be postprocessed, versus a stack which will determine what data it wants to work with, then process the existing data.). Queues are useful in  first come first serve situation. ie. impatient humans who want what they want first because they got there first.

Defining a queue class to delimit the ways you can interact with the array is a recoomended way of forming a queue in Ruby.
=end

	class Queue

		def initialize
			@store = []
		end

		def enqueue(x) 			#Here we are applying syntactical names to the queue operation
			@store << x
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

=begin
The Queue class in the thread library is needed in threaded code. SizedQueue is a variant that is also threadsafe. These classes use the method names enq and deq and allow push and pop (which should not be used in a queue unless you are including a conditional for maintaining your queue size, or want to be able to remove processes once they are in the queue (but we could just use preprocessing to workaround this in queue fashion)).

The queue class can be a good starting point for a thread safe stack class as well.

-----------------------
9.3 Working with trees
-----------------------

A tree is defined by its insertion algorithm and by how it is traversed.

Trees start at the top as the 'root', then the following nodes are 'decendants'. a descendant has a 'child(ren)'' directly below it, and a 'parent' directly above it, and 'ancestors' above that. If a node has no children it is called a 'leaf'.

A tree must accomodate the ability to:
1. store data in each node (one attribute)
2. refer to the left and right subtrees under the node (one attribute each)
3. insert data into the tree
4. get information out of the tree.

These points boil down to how data is inserted and how the tree is traversed.

The example given is of an insert method that inserts top to bottom, and left to right
(breadth first)

-note on breadth first search- 
	A breadth first search identifies items from search key or root first, then left to right moving down the tree. it is able to 'move down the tree' because as it identifies all elements at a certain level of the tree, it is recognizing the attributes of the subtrees, and then has a map of where to iterate over in the next level of nesting in the tree. 
	The ability to discern left and right (binary) allows an evaluation sequence (tree structure) to form for the nested items because it will evaluate left to right.

	Something to keep in mind with a breadth first tree is that it will be consistent in its growth, but its consistency comes from its exponential nature. care should be taken to segment trees accordingly when working with lots of data due to this fact.

=end

class Tree

	#These three attributes give our tree the ability to cover all necessary attributes of a binary tree.
	attr_accessor :left
	attr_accessor :right
	attr_accessor :data

	#setting x to nil allows us to create an empty node, and left and right are nil, as to not create children automatically upon the creation of a node.
	def initialize(x = nil)
		@left = nil
		@right = nil
		@data = x
	end

	def insert(x)
		#This list will hold previous node/children combinations and thusly the whole tree in an array. IT STRIKES ME THAT YOU COULD NOT HAVE SINGLE CHILD NODES WITH THIS APPROACH.
		list = []
		if @data == nil
			@data = x
			#This says that if we have a node, start by creating a left subtree
		elsif @left == nil
			@left = Tree.new(x)
			#If we have a node and a left subtree, create a right subtree
		elsif @right == nil
			@right = Tree.new(x)
			#if we already have a node and a left and a right subtree..
		else
			list << @left
			list << @right
			#This loop prevents us form keeping nil data in our array and ensures that every space in the tree is filled before moving onto the next node creation. 
''			loop do
				node = list.shift
				if node.left == nil
					node.insert(x)
					break
				else
					list << node.left
				end
				if node.right == nil
					node.insert(x)
					break
				else 
					list << node.right
				end
			end
		end
	end

	def traverse()
		#you have to navigate one section at a time with this method.
		list = []
		yield @data
		list << @left if @left != nil
		list << @right if @right != nil
		loop do
			break if list.empty?
			node = list.shift
			yield node.data
			list << node.left if node.left != nil
			list << node.right if node.right != nil
		end
	end

end

items = [1,2,3,4,5,6,7]

tree = Tree.new

items.each {|x| tree.insert(x)}

tree.traverse {|x| print "#{x} "}

class SortTree < Tree

	def insert(x)
		if @data == nil
			@data = x
			#Here we sort the left and right data and insert all of the data in the tree in a sorted order.
		elsif x <= @data
			if @left == nil
				@left = SortTree.new(x)
			else
				@left.insert(x)
			end
		else
			if @right == nil
				@right = SortTree.new(x)
			else 
				@right.insert(x)
			end
		end
	end
	#We recursively iterate through our sorted left and right groups separately and yield the data at different points 
	def inorder()
		@left.inorder {|y| yield y} if @left != nil
		yield @data
		@right.inorder {|y| yield y} if @right != nil
	end

	def preorder()
		yield @data
		@left.preorder {|y| yield y} if @left != nil
		@right.preorder {|y| yield y} if @right != nil
	end

	def postorder()
		@left.postorder {|y| yield y} if @left != nil
		@right.postorder {|y| yield y} if @right != nil
		yield @data
	end
	#I dont understand the structure of this sort.

	#Using this method eliminates the data around the conditional match and recursively shortens the amount of data to search by going left and right close and closer to the number. This algorithm is better visualized as happening over a sorted array ( the form we have stored the binary tree in.)
	#Having the tree sorted is what makes this possible (using sorted binary trees as lookup tables.) This is where the balanced and exponential nature of a binary tree allows for exponential and balanced traversal as well. 		
	def search(x)
		if self.data == x
			return self
		elsif x < self.data
			return left ? left.search(x) : nil
		else 
			return right ? right.search(x) :nil
		end
	end

end

items = [50,20,80,10,30,70,49,34,66,22,3,124,553]

tree = SortTree.new

items.each {|x| tree.insert(x)}
puts
tree.inorder {|x| print x, " "}
puts
tree.preorder {|x| print x, " "}
puts
tree.postorder {|x| print x, " "}


#Searching with binary trees.



tree = SortTree.new

items.each	{|x|	tree.insert(x)}
puts
p s1 = tree.search(70)

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
=begin
Graphs in Ruby

A graph is not necessarily a tree, but a tree is always a graph. This is true because a graph is simply defined as vertices connected in some way.

An undirected graph is simply connected, while a directed graph is connected by one way streets. A weighted graph has connections with associated weights.

=end

class LowerMatrix < TriMatrix
	#A trimatrix allows us to index one value with an x and y coordinate value to create an 'edge' instead of an index.

	#Here we initialize the edge as 0,0, and 0 and inherit the TriMatrix class allowing us to assign values at x,y coordinates.
	def initialize
		@store = ZeroArray.new
	end

end

class Graph

#initialize handles both the creation of one or more or none vertices at a time, as well as adjusting the boundaries of the graph to its greatest extent.
	def initialize(*edges)
		#This creates a trimatrix array vertex that automatically populates with zeros in place of nil values
		@store = LowerMatrix.new
		#This is the variable holding the outer limit of the graph. We probably leave it undefined so the graph will only grow relatably by the max coordinate we insert.
		@max = 0
		edges.each do |edge|
			#I suspect that this is to keep everything in one section of the graph but Im not sure
			edge[0], edge[1] = edge[1], edge[0] if edge[1] > edge[0]
			#I suspect htis allocates a binary 'on' value to the coordinates of each 'edge'
			@store[edge[0], edge[1]] = 1
			#Here we set all of our active values in an array and call the max method on them to set a new graph boundary
			@max = [@max, edge[0], edge[1]].max
		end
	end

	#Here again we are performing swaps based on a greatey y then x comparison.
	#This is a search by coordinate method.
	def [](x,y)
		if x > y
			@store[x,y]
		elsif x < y
			@store[y,x]
		else
			0
		end
	end

	#Here we can allocate values to our defined vertices
	def []=(x,y,value)
		if x > y
			@store[x, y] = value
		elsif x < y
			@store[y, x] = value
		else
			0
		end
	end

	#implicit return conditional to check for the existence of a vertex
	def edge?(x,y)
		x,y = y,x if x<y
		@store[x,y]==1
	end

	#not sure whether this adds a non existing vertex or whether it resets/binary-'on's an existing vertex. I owuld assume that if it could add a vertex beyond the max, there would be a max adjustment method.
	def add(x, y)
		@store[x,y] = 1
	end

	#Will remove the value from an existing vertex
	def remove(x, y)
		x,y = y,x if x<y
		@store[x,y] = 0
		#degree is used here to see if an outer border exists anymore once the value has been removed from a vertex (is off)
		if (degree @max)==0
			@max -= 1
		end
	end

	def vmax
		@max
	end

	#
	def degree(x)
		(0..@max).inject(0){|sum, i| sum + self[x,i] }