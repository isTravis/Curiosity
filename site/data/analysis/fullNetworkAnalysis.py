# We probably will need some things from several places
import sys, os
from pylab import *  # for plotting
from numpy.random import *  # for random sampling
seed(42)
import pickle
import time
# We need to import the graph_tool module itself
from graph_tool.all import *
# import cProfile


def main():
    # let's construct a Price network (the one that existed before Barabasi). It is
    # a directed network, with preferential attachment. The algorithm below is
    # very naive, and a bit slow, but quite simple.

    # We start with an empty, directed graph
    # g = Graph(directed=False)

    # We want also to keep the age information for each vertex and edge. For that
    # let's create some property maps
    # v_age = g.new_vertex_property("int")


    # The final size of the network
    # N = 1000000 #999821


    # nodeIndexes = {}

    # for i in range (1,21):
    # # for i in range (1,2):
    #     print "About to load Node Pickle " + str(i)
    #     tempNodes = pickle.load(open( "pickledData/allResults_" + str(i) + ".p", "rb" )) 
    #     print "Loaded Pickle"


    #     for node in tempNodes:
    #         # print node
    #         v = g.add_vertex()
    #         nodeIndexes[int(node['pageID'])] = int(v)

    # print len(nodeIndexes)
    # pickle.dump(nodeIndexes, open( "nodeIndexes.p", "wb" ) )
    # g.save("justNodes.xml.gz")
    # print "Just saved"





    g = load_graph("justNodes.xml.gz")
    nodeIndexes = pickle.load(open( "nodeIndexes.p", "rb" )) 
    e_strength = g.new_edge_property("int")

    edgecount = 0
    didnthave = 0
    totallength = 0
    dup = 0

    totalPages = 999821
    finishedPages = 0
    startTime = time.time()

    for i in range (1,21):
    # for i in range (1,2):
        print "About to load Edge Pickle " + str(i)
        tempNodes = pickle.load(open( "pickledData/allResults_" + str(i) + ".p", "rb" )) 
        print "Loaded Pickle"


        for node in tempNodes:
            source = nodeIndexes[int(node['pageID'])]
            connections = node['strengths']
            # totallength += len(connections)
            # print source
            
            for connection in connections:
                # try:
                target = nodeIndexes[int(connection)]
                e = g.add_edge(source, target)
                e_strength[e] = connections[connection]
                # edgecount +=1
                    # try:
                    #     # g.add_edge(target, source)
                    #     if g.edge(target, source):
                    #         # print str(source) + " -> " + str(target) + " | dup"
                    #         dup += 1
                            
                    #     else:
                    #         # print str(source) + " -> " + str(target)
                    #         # print g.edge(target, source)
                    #         e = g.add_edge(source, target)
                    #         e_strength[e] = connections[connection]
                    #         edgecount +=1
                    # except:
                    #     # print 'except'
                    #     # print str(source) + " -> " + str(target)
                    #     e = g.add_edge(source, target)
                    #     # print connections[connection]
                    #     e_strength[e] = connections[connection]
                    #     edgecount +=1
                    # # v = g.add_vertex()
                    # # nodeIndexes[int(node['pageID'])] = int(v)
                # except:
                #     # print "Didn't have that id"
                #     didnthave += 1

            finishedPages += 1
            if finishedPages % 10000 == 0:
                lapTime = time.time()
                print "Finished " + str(finishedPages)
                print "Remaining Time: " + str((lapTime-startTime)/finishedPages*(totalPages-finishedPages)/60) + " minutes"
                print "-------------------------"

    g.edge_properties["strength"] = e_strength
    # print edgecount
    # print didnthave
    # print dup
    # print "Sum " + str(edgecount+didnthave+dup)
    print "Total Edges: " + str(totallength)
    g.save("fullNet_redundant.xml.gz")

    print "Removing parallel edges"
    graph_tool.stats.remove_parallel_edges(g)
    print "Done removing parallel, saving..."
    g.save("fullNet.xml.gz")
    print "Done!"







    # pickle, save all the nodes (just in case)

    # Check in the shell the way that undirected edges work. Does edge(2,3) return if edge (3,2) was made in undirected graph?

    # load all the pickles again, iterate over all the connections. 
    # for each connection, find the nodeIndexes
    # get the vertex descriptors : g.vertex(8)
    # check to make sure the edge does not exist yet (in either direction)
    # create the edge : g.add_edge(g.vertex(2), g.vertex(3))
    # assign strength value to edge 
    #     e = g.add_edge(v, target)
    #     e_strength[e] = i
    # save the complete network



    # # We have to start with one vertex
    # v = g.add_vertex()
    # v_age[v] = 0

    # # we will keep a list of the vertices. The number of times a vertex is in this
    # # list will give the probability of it being selected.
    # vlist = [v]

    # # let's now add the new edges and vertices
    # for i in range(1, N):
    #     # create our new vertex
    #     v = g.add_vertex()
    #     v_age[v] = i

    #     # we need to sample a new vertex to be the target, based on its in-degree +
    #     # 1. For that, we simply randomly sample it from vlist.
    #     i = randint(0, len(vlist))
    #     target = vlist[i]

    #     # add edge
    #     e = g.add_edge(v, target)
    #     e_age[e] = i

    #     # put v and target in the list
    #     vlist.append(target)
    #     vlist.append(v)

    # # now we have a graph!

    # # let's do a random walk on the graph and print the age of the vertices we find,
    # # just for fun.

    # v = g.vertex(randint(0, g.num_vertices()))
    # while True:
    #     print("vertex:", v, "in-degree:", v.in_degree(), "out-degree:",\
    #           v.out_degree(), "age:", v_age[v])

    #     if v.out_degree() == 0:
    #         print("Nowhere else to go... We found the main hub!")
    #         break

    #     n_list = []
    #     for w in v.out_neighbours():
    #         n_list.append(w)
    #     v = n_list[randint(0, len(n_list))]

    # # let's save our graph for posterity. We want to save the age properties as
    # # well... To do this, they must become "internal" properties:

    # g.vertex_properties["age"] = v_age
    # g.edge_properties["age"] = e_age

    # # now we can save it
    # g.save("price.xml.gz")


    # # Let's plot its in-degree distribution
    # in_hist = vertex_hist(g, "in")

    # y = in_hist[0]
    # err = sqrt(in_hist[0])
    # err[err >= y] = y[err >= y] - 1e-2

    # figure(figsize=(6,4))
    # errorbar(in_hist[1][:-1], in_hist[0], fmt="o", yerr=err,
    #         label="in")
    # gca().set_yscale("log")
    # gca().set_xscale("log")
    # gca().set_ylim(1e-1, 1e5)
    # gca().set_xlim(0.8, 1e3)
    # subplots_adjust(left=0.2, bottom=0.2)
    # xlabel("$k_{in}$")
    # ylabel("$NP(k_{in})$")
    # tight_layout()
    # savefig("price-deg-dist.pdf")
    # savefig("price-deg-dist.png")

main()
# cProfile.run('main()')



