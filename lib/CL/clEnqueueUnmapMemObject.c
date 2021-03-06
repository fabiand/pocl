/* OpenCL runtime library: clEnqueueUnmapMemObject()

   Copyright (c) 2012 Pekka Jääskeläinen / Tampere University of Technology
   
   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:
   
   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.
   
   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
*/

#include "pocl_cl.h"
#include "utlist.h"
#include <assert.h>
#include "pocl_util.h"

CL_API_ENTRY cl_int CL_API_CALL
POname(clEnqueueUnmapMemObject)(cl_command_queue command_queue,
                        cl_mem           memobj,
                        void *           mapped_ptr,
                        cl_uint          num_events_in_wait_list,
                        const cl_event * event_wait_list,
                        cl_event *       event) CL_API_SUFFIX__VERSION_1_0
{
  int errcode;
  cl_device_id device_id;
  unsigned i;
  mem_mapping_t *mapping = NULL;
  _cl_command_node *cmd;

  if (memobj == NULL)
    return CL_INVALID_MEM_OBJECT;

  if (command_queue == NULL || command_queue->device == NULL ||
      command_queue->context == NULL)
    return CL_INVALID_COMMAND_QUEUE;

  if (command_queue->context != memobj->context)
    return CL_INVALID_CONTEXT;

  DL_FOREACH (memobj->mappings, mapping)
    {
      if (mapping->host_ptr == mapped_ptr)
          break;
    }
  if (mapping == NULL)
    return CL_INVALID_VALUE;

  /* find the index of the device's ptr in the buffer */
  device_id = command_queue->device;
  for (i = 0; i < command_queue->context->num_devices; ++i)
    {
      if (command_queue->context->devices[i] == device_id)
        break;
    }

  assert(i < command_queue->context->num_devices);

  if (event != NULL)
    {
      errcode = pocl_create_event (event, command_queue, 
                                   CL_COMMAND_UNMAP_MEM_OBJECT);
      if (errcode != CL_SUCCESS)
        goto ERROR;
      POCL_UPDATE_EVENT_QUEUED;
    }

  errcode = pocl_create_command (&cmd, command_queue, 
                                 CL_COMMAND_UNMAP_MEM_OBJECT, 
                                 event, num_events_in_wait_list, 
                                 event_wait_list);
  if (errcode != CL_SUCCESS)
    goto ERROR;
  
  cmd->command.unmap.data = command_queue->device->data;
  cmd->command.unmap.memobj = memobj;
  cmd->command.unmap.mapping = mapping;
  LL_APPEND(command_queue->root, cmd);

  POCL_UPDATE_EVENT_SUBMITTED;

  return CL_SUCCESS;

 ERROR:
  free (*event);
  free (cmd);
  return errcode;
}
POsym(clEnqueueUnmapMemObject)
