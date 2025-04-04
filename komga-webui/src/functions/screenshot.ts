import html2canvas from 'html2canvas'
import domtoimage from 'dom-to-image'

export async function partialScreenshot(element: any): Promise<string> {
    return html2canvas(
      element,
      {
        allowTaint: true,
        useCORS: true,
        foreignObjectRendering: true,
      })
      .then(function(canvas: any) {
          return returnBlob(canvas)
      })
  }

function returnBlob(canvas: any): string {
    const link = document.createElement('a')
    link.download = 'image.png'
    return canvas.toDataURL('image/png', 1.0)
}

export async function partialScreenshotWithDomToImage(element: any): Promise<string> {
  // Attempt 10 times to take a screenshot, retrying if the image size is small - Thanks Safari
  for (let i = 0; i < 10; i++) {
    const dataUrl = await domtoimage.toPng(element)
    console.log('dataUrl', dataUrl.length / 1024)
    if (dataUrl.length / 1024 > 100) {
      return dataUrl
    }
  }
  return ''
}